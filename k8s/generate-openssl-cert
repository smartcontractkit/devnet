#!/bin/bash
# Taken from https://devcenter.heroku.com/articles/ssl-certificate-self

mkdir -p tmp

cd tmp
openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
openssl rsa -passin pass:x -in server.pass.key -out server.key
rm server.pass.key

echo
echo "** Must enter domain name in Common Name(CN) and must enter empty challenge password"
echo
openssl req -new -key server.key -out server.csr

openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt

echo
echo "** Files are in tmp/"
