# Mondo Shell Utilities

This is a collection of scripts that:

1. Implements the Mondo authentication flow using OAuth
2. Downloads transactions via the Mondo API
3. Exports Mondo transaction records as OFX files

# Dependencies

These tools use `httpie`, Python 2.7, and `jq`.

# Usage

## Setup
To use these scripts you need to [register a new OAuth Client with Mondo](https://developers.getmondo.co.uk/apps/new).

Copy the client ID and client secret into the `.client_id` and `.client_secret` files respectively. If you try to run the scripts without doing this, they will optionally do this for you.

## Logging In

Once you have a Client ID, you can log in by running `./login.sh`. 

	% ./login.sh 

This will open the browser to the Mondo authorisation page. You might see a request from your firewall to allow Python to listen n port 8118; allow it. Enter your email address in the Mondo log in page an Mondo will send you an activation link.

Follow that link and you will be taken to a `localhost` URL. This contains the code that gets exchanged for an OAuth token. The Python web server will pick that up and exit.

If this works the authentication token will be dumped into `.access_token`. You can now use the [API calls listed in the documentation](https://getmondo.co.uk/docs/#acquire-an-access-token). The included scripts automate the `accounts` and `transaction` endpoints.

# API Calls

### Accounts

The `./accounts.sh` script will fetch the account ID and store it in `.account_id`.

### Transactions

The `./transactions.sh` script will dump JSON transactions to the console.

	% ./transactions.sh
	{
	    "transactions": [
	        {
	            "account_balance": 10000,
	            "account_id": "acc_1234",
	            "amount": 10000,
	            "attachments": [],
	            "category": "mondo",
	            "counterparty": {},
	            "created": "1970-01-01T00:00:00.000Z",
	            "currency": "GBP",
	            "dedupe_id": "01189998819991197253",
	            "description": "Initial top up",
	            "id": "tx_00009BEEFBEEFBEEF",
	            "is_load": true,
	            "local_amount": 10000,
	            "local_currency": "GBP",
	            "merchant": null,
	            "metadata": {
	                "is_topup": "true"
	            },
	            "notes": "",
	            "originator": false,
	            "scheme": "gps_mastercard",
	            "settled": "1970-01-01T00:00:00.000Z",
	            "updated": "1970-01-01T00:00:00.000Z"
	        }
		]
	}

Use `jq` to process the output:

	% ./transactions.sh | jq '[.transactions[] | .amount] | reduce .[] as $item (0; . + $item)'
	4806

(Note that balances are in pence).

# OFX Export

The `./ofx.sh` script accepts a filename for a JSON file and transforms it into a file that looks enough like one that YNAB reads it.

	% ./transactions.sh > "transactions.json"
	% ./ofx.sh transactions.json > transactions.ofx

# Notes

This is a quick and dirty hack for a number of reasons:

1. It doesn't have a proper redirect URL
2. Tokens expire and will need to be regenerated (instead of refreshing them)
3. It leaves credentials in the clear on your hard drive