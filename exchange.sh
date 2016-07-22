#!/usr/bin/env bash
. ./credentials

cat <<INFO
Your web browser should have opened a localhost address.
This contains your OAuth code that can be converted to an
access token.

Paste the url you got from mondo here to get a token:
INFO;
read url
params="$(echo $url | cut -d '?' -f 2 | tr '&' '\n' | grep code | tr -d '\n')"
code=$(echo $params | cut -d '=' -f 2) 



http -b --form POST 'https://api.getmondo.co.uk/oauth2/token' \
	grant_type=authorization_code \
	client_id=$ClientID \
	client_secret=$ClientSecret \
	redirect_uri='http://localhost' \
	code=$code | jq .access_token > .access_token
