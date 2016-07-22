. ./credentials

StateToken=$(dd if=/dev/random bs=1 count=32 | xxd -p)

cat <<INFO
Your browser will open asking you to log in to Mondo.
You will get an email. Follow that link and you will be
redirected to localhost. 

Copy the URL (from the URL bar) and run ./exchange.sh
INFO

open "https://auth.getmondo.co.uk/?\
client_id=$ClientID&\
redirect_uri=http://localhost&\
response_type=code&\
state=$StateToken"