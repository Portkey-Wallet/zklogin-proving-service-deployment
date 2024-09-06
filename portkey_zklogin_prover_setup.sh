#!/bin/bash

CIRCUIT_VERSION=v3.1.0-test.1
circuitName=zkLogin

# Update and install dependencies
apt-get update
apt-get install -y docker.io docker-compose curl unzip

# Create directory for the zkLogin files
mkdir -p /opt/portkey-zklogin
filesDir=/opt/portkey-zklogin/files

mkdir -p $filesDir

# Download the zip file to the target directory
curl -L "https://github.com/Portkey-Wallet/zkLogin-circuit/releases/download/${CIRCUIT_VERSION}/${circuitName}-${CIRCUIT_VERSION}.zip" --silent -o $filesDir/$circuitName.zip

# Unzip the downloaded file
unzip -o $filesDir/$circuitName.zip -d $filesDir && rm $filesDir/$circuitName.zip

# Download the zkLogin_final.zkey file
curl -L https://portkey-zklogin-ph2-ceremony.s3.amazonaws.com/circuits/zklogin/contributions/zklogin_final.zkey -o $filesDir/zkLogin_final.zkey

# Create docker-compose.yml file
cat << EOF > /opt/portkey-zklogin/docker-compose.yml
version: '3'
services:
  proverPoseidon:
    image: mysten/zklogin@sha256:26c46a8f91533b6921137b6541f98db257adc22bb5f992b1b54c686546aeabf7
    environment:
      - ZKEY=/app/files/zkLogin_final.zkey
      - WITNESS_BINARIES=/app/files
    volumes:
      - ./files:/app/files
  provingServicePoseidon:
    image: portkeydid/proving-service:v3.3.2
    volumes:
      - ./appsettings.json:/app/appsettings.json
      - ./files:/app/files
    ports:
      - 80:7020
EOF

# Create appsettings.json file
cat << EOF > /opt/portkey-zklogin/appsettings.json
{
    "FeatureManagement": {
      "UsePoseidon": true
    },
    "Serilog": {
      "MinimumLevel": "Debug"
    },
    "ProverServerSettings": {
        "Endpoint": "http://proverPoseidon:8080/input"
    },
    "JwksSettings": {
      "Endpoints": [
        "https://www.googleapis.com/oauth2/v3/certs",
        "https://limited.facebook.com/.well-known/oauth/openid/jwks/",
        "https://appleid.apple.com/auth/keys"
      ],
      "Timeout": "00:02:00"
    },
    "CircuitSettings": {
        "R1csPath": "/app/files/zkLogin.r1cs",
        "WasmPath": "/app/files/zkLogin.wasm",
        "ZkeyPath": "/app/files/zkLogin_final.zkey"
    }
  }
EOF

# Run Docker Compose
cd /opt/portkey-zklogin
docker-compose up -d