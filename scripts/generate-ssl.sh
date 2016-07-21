#!/usr/bin/env bash

# Specify where we will install
# the local.com certificate
SSL_DIR="./conf/nginx/certs/"

# Set the wildcarded domain
# we want to use
DOMAIN="drupal.docker"

# A blank passphrase
PASSPHRASE=""

# Set our CSR variables
SUBJ="
C=US
ST=Connecticut
O=
localityName=New Haven
commonName=$DOMAIN
organizationalUnitName=
emailAddress=
"

# Generate our Private Key, CSR and Certificate
#sudo openssl genrsa -out "$SSL_DIR/4ad.local.com.key" 2048
openssl genrsa -des3 -passout pass:x -out $DOMAIN.pass.key 2048
#sudo openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/local.com.key" -out "$SSL_DIR/4ad.local.com.csr" -passin pass:$PASSPHRASE
openssl rsa -passin pass:x -in $DOMAIN.pass.key -out $DOMAIN.key
rm $DOMAIN.pass.key
#openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/local.com.key" -out "$SSL_DIR/4ad.local.com.csr" -passin pass:$PASSPHRASE
openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key $DOMAIN.key -out $DOMAIN.csr

#sudo openssl x509 -req -days 365 -in "$SSL_DIR/local.com.csr" -signkey "$SSL_DIR/local.com.key" -out "$SSL_DIR/4ad.local.com.crt"
openssl x509 -req -days 365 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.crt
