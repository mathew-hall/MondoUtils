. ./credentials

http -b "https://api.getmondo.co.uk/accounts" \
    "Authorization: Bearer $access_token" | jq .accounts[].id | tr -d '"' > .account_id

echo "Account ID: $account_id"