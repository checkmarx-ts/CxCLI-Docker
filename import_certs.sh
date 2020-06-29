#!/bin/sh

cd `dirname $0`

for certfile in $(ls *.crt *.cer 2> /dev/null)
do
    keytool -importcert -file $certfile -alias $certfile -cacerts -storepass changeit -noprompt
done
