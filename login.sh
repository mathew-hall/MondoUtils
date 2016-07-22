#!/usr/bin/env bash
set -e
. ./credentials
StateToken=$(dd if=/dev/random bs=1 count=32 2>/dev/null | xxd -p)

open "https://auth.getmondo.co.uk/?\
client_id=$ClientID&\
redirect_uri=http://localhost:8118/credentials&\
response_type=code&\
state=$StateToken"

export code=$(python get_token.py)

http -b --form POST 'https://api.getmondo.co.uk/oauth2/token' \
	grant_type=authorization_code \
	client_id=$ClientID \
	client_secret=$ClientSecret \
	redirect_uri='http://localhost:8118/credentials' \
	code=$code | jq -r .access_token > .access_token
