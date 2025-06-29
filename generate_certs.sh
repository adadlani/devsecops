#!/bin/bash

# Create a directory for certificates
mkdir -p certs

# Generate the private key for the CA certificate
openssl genpkey -algorithm RSA -out certs/ca-key.pem

# Generate CA certificate
openssl req -new -x509 -sha256 -days 365 -key certs/ca-key.pem -out certs/ca.pem -subj "/CN=ELK CA"

# Generate private key for the server
openssl genpkey -algorithm RSA -out certs/elastic-key.pem

# Create a config file for the certificate request
cat > certs/elastic-req.conf << EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = elastic

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = elasticsearch
DNS.2 = localhost
IP.1 = 127.0.0.1
EOF

# Generate certificate signing request
openssl req -new -key certs/elastic-key.pem -out certs/elastic.csr -config certs/elastic-req.conf

# Generate the server certificate
openssl x509 -req -in certs/elastic.csr -CA certs/ca.pem -CAkey certs/ca-key.pem -CAcreateserial -out certs/elastic.pem -days 365 -extensions v3_req -extfile certs/elastic-req.conf

# Convert the certificate and key to PKCS12 format
openssl pkcs12 -export -in certs/elastic.pem -inkey certs/elastic-key.pem -out certs/elastic.p12 -name "elastic" -passout pass:elastic
