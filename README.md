# Mondo Shell Utilities

This is a collection of scripts that:

1. Implements the Mondo authentication flow using OAuth
2. Downloads transactions via the Mondo API
3. Exports Mondo transaction records as OFX files

# Dependencies

These tools use `httpie` and `jq`.

# Usage

## Setup
To use these scripts you need to [register a new OAuth Client with Mondo](https://developers.getmondo.co.uk/apps/new).

Copy the client ID and client secret into the `.client_id` and `.client_secret` files respectively. If you try to run the scripts without doing this, they will optionally do this for you.

## Logging In

Once you have a Client ID, you can log in by running `./login.sh`. 

	% ./login.sh 
	Your browser will open asking you to log in to Mondo.
	You will get an email. Follow that link and you will be
	redirected to localhost. 
    
	Copy the URL (from the URL bar) and run ./exchange.sh

This will open the browser to the Mondo authorisation page. Enter your email address and you will get a link to authorise your app. Follow that link and you will be taken to a `localhost` URL. This contains the code that gets exchanged for an OAuth token. *Copy and paste* the localhost URL.

Use `./exchange.sh` to get an authorisation token from the code in the URL:

	% ./exchange.sh 
	Your web browser should have opened a localhost address.
	This contains your OAuth code that can be converted to an
	access token.
	
	Paste the url you got from mondo here to get a token:

Enter the token and hit return:

	http://localhost/?code=<lots of chars>&state=<more chars>

If this works the token will be dumped into `.access_token`. You can now use the [API calls listed in the documentation](https://getmondo.co.uk/docs/#acquire-an-access-token). The included scripts automate the `accounts` and `transaction` endpoints.

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