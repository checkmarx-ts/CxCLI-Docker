#!/bin/sh

cd `dirname $0`

for certfile in $(ls *.crt *.cer 2> /dev/null)
do
    keytool -importcert -file $certfile -alias $certfile -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -noprompt
done
