#!/bin/sh

# Generate Certificate for main authority
# It will approve certificates of other participants (services)
CANAME=ca

openssl genpkey -algorithm ed25519 -out $CANAME.key
openssl req -x509 -new -nodes -key $CANAME.key -days 1826 -out $CANAME.crt -subj
'/C=UA/ST=Kyiv/L=Kyiv/O=Goit/OU=IT/CN=Test CA Cert' -addext "subjectAltName = DNS:localhost"
cd ..

# YOUR APPS KEYS
SERVICE=acra-client
mkdir $SERVICE
cd $SERVICE
openssl genpkey -algorithm ed25519 -out $SERVICE.key
openssl req -new -nodes -key $SERVICE.key -out $SERVICE.csr -subj "/C=UA/ST=Kyiv/L=Kyiv/O=Goit/OU=IT/CN=Test Node Cert ($SERVICE)"
cat > $SERVICE.v3.ext << EOF
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = $SERVICE
EOF
openssl x509 -req -in $SERVICE.csr -CA ./../$CANAME/$CANAME.crt -CAkey ./../$CANAME/$CANAME.key -CAcreateserial -out $SERVICE.crt -days 730 -extfile $SERVICE.v3.ext
cd ..

# Server's certs
SERVICE=acra-server
openssl genpkey -algorithm ed25519 -out $SERVICE.key
openssl req -new -nodes -key $SERVICE.key -out $SERVICE.crt -subj "/C=UA/ST=Kyiv/L=Kyiv/O=Goit/OU=IT/CN=Test Node Cert ($SERVICE)"
cat > $SERVICE.v3.ext << EOF
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment
subjectAltName = @alt_names
authorityInfoAccess = OCSP;URI:http://127.0.0.1:8888
crlDistributionPoints=crldp1_section

[crldp1_section]
fullname=URI:http://127.0.0.1:8889/crl.pem

[alt_names]
DNS.1 = localhost
DNS.2 = $SERVICE
EOF
openssl x509 -req -in $SERVICE.crt -CA ./../$CANAME/$CANAME.crt 
-CAkey ./../$CANAME/$CANAME.key -CAcreateserial -out $SERVICE.crt -days 730 -extfile $SERVICE.v3.ext
cd ..

# MySql certificates
SERVICE=mysql
mkdir $SERVICE
cd $SERVICE
openssl genpkey -algorithm ed25519 -out $SERVICE.key
openssl req -new -nodes -key $SERVICE.key -out $SERVICE.csr -subj "/C=UA/ST=Kyiv/L=Kyiv/O=Goit/OU=IT/CN=Test Node Cert ($SERVICE)"
cat > $SERVICE.v3.ext << EOF
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = $SERVICE
EOF
openssl x509 -req -in $SERVICE.csr -CA ./../$CANAME/$CANAME.crt -CAkey ./../$CANAME/$CANAME.key
-CAcreateserial -out $SERVICE.crt -days 730 -extfile $SERVICE.v3.ext
cd ..

# Postgresql's certificates
SERVICE=postgresql
mkdir $SERVICE
cd $SERVICE
openssl genpkey -algorithm ed25519 -out $SERVICE.key
openssl req -new -nodes -key $SERVICE.key -out $SERVICE.csr -subj "/C=UA/ST=Kyiv/L=Kyiv/O=Goit/OU=IT/CN=Test Node Cert ($SERVICE)"
cat > $SERVICE.v3.ext << EOF
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = $SERVICE
EOF
openssl x509 -req -in $SERVICE.csr -CA ./../$CANAME/$CANAME.crt -CAkey ./../$CANAME/$CANAME.key -CAcreateserial -out $SERVICE.crt -days 730 -extfile $SERVICE.v3.ext
cd ..

# Not used in our case
SERVICE=acra-translator
mkdir $SERVICE
cd $SERVICE
openssl genpkey -algorithm ed25519 -out $SERVICE.key
openssl req -new -nodes -key $SERVICE.key -out $SERVICE.crt -subj "/C=UA/ST=Kyiv/L=Kyiv/O=Goit/OU=IT/CN=Test Node Cert ($SERVICE)"
cat > $SERVICE.v3.ext << EOF
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment
subjectAltName = @alt_names
authorityInfoAccess = OCSP;URI:http://127.0.0.1:8888
crlDistributionPoints=crldp1_section

[crldp1_section]
fullname=URI:http://127.0.0.1:8889/crl.pem

[alt_names]
DNS.1 = localhost
DNS.2 = $SERVICE
EOF
openssl x509 -req -in $SERVICE.crt -CA ./../$CANAME/$CANAME.crt -CAkey ./../$CANAME/$CANAME.key -CAcreateserial -out $SERVICE.crt -days 730 -extfile $SERVICE.v3.ext
cd ..

# Not used in our case
SERVICE=acra-client2
mkdir $SERVICE
cd $SERVICE
openssl genpkey -algorithm ed25519 -out $SERVICE.key
openssl req -new -nodes -key $SERVICE.key -out $SERVICE.csr -subj "/C=UA/ST=Kyiv/L=Kyiv/O=Goit/OU=IT/CN=Test Node Cert ($SERVICE)"
cat > $SERVICE.v3.ext << EOF
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = $SERVICE
EOF
openssl x509 -req -in $SERVICE.csr -CA ./../$CANAME/$CANAME.crt -CAkey ./../$CANAME/$CANAME.key -CAcreateserial -out $SERVICE.crt -days 730 -extfile $SERVICE.v3.ext
cd ..

