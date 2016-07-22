end_date=$(jq '[.transactions[] .created] | max | split("T")[0]' $1 | tr -d '-')
start_date=$(jq '[.transactions[] .created] | min | split("T")[0]' $1 | tr -d '-')
account_id="mondo"
cat <<END
z
OFXHEADER:100
DATA:OFXSGML
VERSION:102
SECURITY:NONE
ENCODING:USASCII
CHARSET:1252
COMPRESSION:NONE
OLDFILEUID:NONE
NEWFILEUID:NONE

<OFX>
<SIGNONMSGSRSV1>
<SONRS>
<STATUS>
<CODE>0</CODE>
<SEVERITY>INFO</SEVERITY>
</STATUS>
<DTSERVER>$end_date</DTSERVER>
<LANGUAGE>ENG</LANGUAGE>
<INTU.BID>00000</INTU.BID>
</SONRS>
</SIGNONMSGSRSV1>
<BANKMSGSRSV1>
<STMTTRNRS>
<TRNUID>1</TRNUID>
<STATUS>
<CODE>0</CODE>
<SEVERITY>INFO</SEVERITY>
</STATUS>
<STMTRS>
<CURDEF>GBP</CURDEF>
<BANKACCTFROM>
<BANKID>MONDO MONDO MONDO</BANKID>
<ACCTID>$account_id</ACCTID>
<ACCTTYPE>CHECKING</ACCTTYPE>
</BANKACCTFROM>
<BANKTRANLIST>
<DTSTART>$start_date</DTSTART>
<DTEND>$end_date</DTEND>
END




jq -r '.transactions[] | 
"<STMTTRN>
<TRNTYPE>POS</TRNTYPE>
<DTPOSTED>\(.created | split("T")[0] | split("-")[0:3] | join(""))</DTPOSTED>
<TRNAMT>\(.amount/100)</TRNAMT>
<FITID>\(.id)</FITID>
<NAME>\(.description)</NAME>
<MEMO>\(.category)</MEMO>
</STMTTRN>"' $1

cat <<END
</BANKTRANLIST>
</STMTRS>
</STMTTRNRS>
</BANKMSGSRSV1>
</OFX>
