#!/bin/bash
#
# Author: Dulaj Dilshan
#
#
# Exit on first error
set -e

export MSYS_NO_PATHCONV=1
starttime=$(date +%s)
CC_SRC_LANGUAGE="go"
CC_RUNTIME_LANGUAGE=golang
CC_SRC_PATH=github.com/chaincode/mschain

# clean the keystore
rm -rf ./hfc-key-store

# launch network; create channel and join peer to channel
cd ./telarana-network
echo y | ./byfn.sh down
echo y | ./byfn.sh up -a -n -s couchdb -o kafka -c mychannel

CONFIG_ROOT=/opt/gopath/src/github.com/hyperledger/fabric/peer
ORG1_MSPCONFIGPATH=${CONFIG_ROOT}/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
ORG1_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
ORG2_MSPCONFIGPATH=${CONFIG_ROOT}/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
ORG2_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
ORDERER_TLS_ROOTCERT_FILE=${CONFIG_ROOT}/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
set -x

echo "Installing smart contract on peer0.org1.example.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG1_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n mschain \
    -v 1.0 \
    -p "$CC_SRC_PATH" \
    -l "$CC_RUNTIME_LANGUAGE"

echo "Installing smart contract on peer1.org1.example.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_ADDRESS=peer1.org1.example.com:8051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG1_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n mschain \
    -v 1.0 \
    -p "$CC_SRC_PATH" \
    -l "$CC_RUNTIME_LANGUAGE"

echo "Installing smart contract on peer0.org2.example.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org2MSP \
  -e CORE_PEER_ADDRESS=peer0.org2.example.com:9051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG2_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG2_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n mschain \
    -v 1.0 \
    -p "$CC_SRC_PATH" \
    -l "$CC_RUNTIME_LANGUAGE"

echo "Installing smart contract on peer1.org2.example.com"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org2MSP \
  -e CORE_PEER_ADDRESS=peer1.org2.example.com:10051 \
  -e CORE_PEER_MSPCONFIGPATH=${ORG2_MSPCONFIGPATH} \
  -e CORE_PEER_TLS_ROOTCERT_FILE=${ORG2_TLS_ROOTCERT_FILE} \
  cli \
  peer chaincode install \
    -n mschain \
    -v 1.0 \
    -p "$CC_SRC_PATH" \
    -l "$CC_RUNTIME_LANGUAGE"

echo "Instantiating smart contract on mychannel"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  cli \
  peer chaincode instantiate \
    -o orderer.example.com:7050 \
    -C mychannel \
    -n mschain \
    -l "$CC_RUNTIME_LANGUAGE" \
    -v 1.0 \
    -c '{"Args":[]}' \
    -P "AND('Org1MSP.member','Org2MSP.member')" \
    --tls \
    --cafile ${ORDERER_TLS_ROOTCERT_FILE} \
    --peerAddresses peer0.org1.example.com:7051 \
    --tlsRootCertFiles ${ORG1_TLS_ROOTCERT_FILE}

echo "Waiting for instantiation request to be committed ..."
sleep 10

echo "Submitting initLedger transaction to smart contract on mychannel"
echo "The transaction is sent to all of the peers so that chaincode is built before receiving the following requests"
docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_MSPCONFIGPATH=${ORG1_MSPCONFIGPATH} \
  cli \
  peer chaincode invoke \
    -o orderer.example.com:7050 \
    -C mychannel \
    -n mschain \
    -c '{"function":"addCertificate","Args":["-----BEGIN CERTIFICATE-----\nMIIDmzCCAoMCCQDz6obA2B2drDANBgkqhkiG9w0BAQsFADCBiTELMAkGA1UEBhMC\nSU4xEjAQBgNVBAgMCU5ldyBEZWxoaTESMBAGA1UEBwwJTmV3IERlbGhpMQwwCgYD\nVQQKDANDQTIxDjAMBgNVBAsMBUFkbWluMRYwFAYDVQQDDA1hZG1pbi5jYTIuY29t\nMRwwGgYJKoZIhvcNAQkBFg1hZG1pbkBjYTIuY29tMB4XDTE4MDQxNzA1NDcyMVoX\nDTIxMDIwNDA1NDcyMVowgZQxCzAJBgNVBAYTAklOMRIwEAYDVQQIDAlOZXcgRGVs\naGkxEjAQBgNVBAcMCU5ldyBEZWxoaTEZMBcGA1UECgwQRGVsaGkgVW5pdmVyc2l0\neTEOMAwGA1UECwwFQWRtaW4xEjAQBgNVBAMMCWR1LmVkdS5pbjEeMBwGCSqGSIb3\nDQEJARYPYWRtaW5AZHUuZWR1LmluMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB\nCgKCAQEA1rewijwmODmYjMMGuBL+sEA0G2GjHVVBtp9+agxpZaI9Yc4tm2vZzCEz\ndQMQS4CoJzbA20zjsNNrrEHwKup/+OwzDpI5Lqncpvvy8qQaR5X1XJia4dJpPupd\nClkD+kmImyg2Ev5Wqwljp/oujMc9hjz55P9YuBp/vZMxLGrwdaWQXRe2/RNBHA6N\nOPn+8Kq1FoKOYNFrWcG8oHhIbph4SkAh/78YavSNU61Nq2gCN+9Z5qleU6MS0R4n\n1DWXLQ7MTY5LpJ/1N8jt+4q9ynoE9644896t9A9OEgcfW8zeWhmRsfZWpnO+1C95\nzImXJxxBlUNULmOKoPrWmzKt3QYmiQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCz\n9ibSvf6uIeQ09Ve0LFDv3UKfbweAo9YCilzu8ZCM1hmE6EMxH0AtJUEFnAqej9rN\nA1m2AoXn8zxqvQYZOUalOYmW7O85QA6zZ4XHsO5YAnYlS3zkxJ5UN2bdUyVgr9Hv\nmydY8Z13HsNloLu63E7iOQAemfRcKBKFq00NL51sGIGgTLXCN4qVpLil9iplgy7m\n3/bZFL5grIPrtuMyV7wl1gEvFoGef9Dvga1kGrmZdMkJzv4h1eMspjFhtUfOV/lc\nIY+QKXI5NSm0ihJMHAXn3MmRUS9za0IH4TSg+zJiKQQFzlCfjxzR93tr4zcOGEWn\n9aaySafV35SI798fJ0I2\n-----END CERTIFICATE-----","-----BEGIN CERTIFICATE-----\nMIIDkDCCAngCCQDJBoCV8HRlvjANBgkqhkiG9w0BAQsFADCBiTELMAkGA1UEBhMC\nSU4xEjAQBgNVBAgMCU5ldyBEZWxoaTESMBAGA1UEBwwJTmV3IERlbGhpMQwwCgYD\nVQQKDANDQTIxDjAMBgNVBAsMBUFkbWluMRYwFAYDVQQDDA1hZG1pbi5jYTIuY29t\nMRwwGgYJKoZIhvcNAQkBFg1hZG1pbkBjYTIuY29tMB4XDTE4MDQxNzA1MzUxMloX\nDTIxMDIwNDA1MzUxMlowgYkxCzAJBgNVBAYTAklOMRIwEAYDVQQIDAlOZXcgRGVs\naGkxEjAQBgNVBAcMCU5ldyBEZWxoaTEMMAoGA1UECgwDQ0EyMQ4wDAYDVQQLDAVB\nZG1pbjEWMBQGA1UEAwwNYWRtaW4uY2EyLmNvbTEcMBoGCSqGSIb3DQEJARYNYWRt\naW5AY2EyLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjdbaz+\nOnjCIMkcDqrL+lHJDE0FJ5MatWQ3METe+jpRW+vsyibU9bu3QhS7HZgH6S9//Inb\n4EUaxbTw6pKipM364gn80Dv/Jm0lStVzGy7dpMSwoTecRAEOUStIa4wEtZck3hM5\nmBz+IRFRI9WVg522aRA28GaNhcw5ZY9O0lv1RJC2BpxpqiDV0xgJ6Js7y+6VR7WC\n+QozE6S5pInCbx2gAbHqip9iIJcp7rWUgsr5HVsrxU4DybevP4E14dKrwBRje8wF\n0/I0yg7FVYRJlARRk2/hakxkceIdNGi+yZWgRqexON6cpUm1XJvZBXbxOMgZYNlt\nFd3jESGqNZlJAQcCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAaxEnwfe77jZtGIf+\n2Ecm7Qe5PdtdLOG1NvE3fnWzXF39YS8pYFX0JdcOaQRnzv261Lne4/Ca0HVL8iWP\nZOti8jMEIfQoOSAJl8VfNPft4UVT70CUGatoskILdl8YsCJUcA/7c4p0TNxPsKuU\nwtzKTWCl584ovg3VTuNMjyGz4/dsRtysGRAxdmRLCnNTqwj1CnzFZwMu3xW6Yjma\nxdK6dckOcU8QRw6K8f4mZrObzepAWjiadyiMc94jl1RPeBqhRxV0MyXJKmYcq135\nvgRLcieiEGjyuNOzoflJl7bWtseLVWfTeQdzQOA3UHCIhGI7dkTisQCvt4Pw0A1O\np+2cQw==\n-----END CERTIFICATE-----",""]}' \
    --waitForEvent \
    --tls \
    --cafile ${ORDERER_TLS_ROOTCERT_FILE} \
    --peerAddresses peer0.org1.example.com:7051 \
    --peerAddresses peer1.org1.example.com:8051 \
    --peerAddresses peer0.org2.example.com:9051 \
    --peerAddresses peer1.org2.example.com:10051 \
    --tlsRootCertFiles ${ORG1_TLS_ROOTCERT_FILE} \
    --tlsRootCertFiles ${ORG1_TLS_ROOTCERT_FILE} \
    --tlsRootCertFiles ${ORG2_TLS_ROOTCERT_FILE} \
    --tlsRootCertFiles ${ORG2_TLS_ROOTCERT_FILE}
set +x

cat <<EOF
Total setup execution time : $(($(date +%s) - starttime)) secs ...
EOF