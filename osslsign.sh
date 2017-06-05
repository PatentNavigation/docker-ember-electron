#!/bin/bash

IN_FILE=$1
CERT_PATH=$2
CERT_PASS=$3

osslsigncode sign -pkcs12 $CERT_PATH -pass $CERT_PASS -in $IN_FILE -out $IN_FILE.sha1  -h sha1 -t http://timestamp.verisign.com/scripts/timstamp.dll || exit 1
osslsigncode sign -pkcs12 $CERT_PATH -pass $CERT_PASS -in $IN_FILE.sha1 -out $IN_FILE.sha2 -nest -h sha256 -t http://timestamp.verisign.com/scripts/timstamp.dll || exit 1

mv $IN_FILE.sha2 $IN_FILE || exit 1
rm $IN_FILE.sha1
