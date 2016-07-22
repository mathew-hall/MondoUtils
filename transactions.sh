#!/usr/bin/env bash
. ./credentials

http -b "https://api.getmondo.co.uk/transactions" \
    "Authorization: Bearer $access_token" \
    "account_id==$account_id"