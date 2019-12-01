docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_ADDRESS=peer0.org1.example.com:7051 \
  -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
  cli \
  peer chaincode install \
    -n ctb \
    -v 1.0 \
    -p "github.com/chaincode/ctb" \
    -l "golang"


docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_ADDRESS=peer1.org1.example.com:8051 \
  -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt \
  cli \
  peer chaincode install \
    -n ctb \
    -v 1.0 \
    -p "github.com/chaincode/ctb" \
    -l "golang"

docker exec \
  -e CORE_PEER_LOCALMSPID=Org2MSP \
  -e CORE_PEER_ADDRESS=peer0.org2.example.com:9051 \
  -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
  cli \
  peer chaincode install \
    -n ctb \
    -v 1.0 \
    -p "github.com/chaincode/ctb" \
    -l "golang"


docker exec \
  -e CORE_PEER_LOCALMSPID=Org2MSP \
  -e CORE_PEER_ADDRESS=peer1.org2.example.com:10051 \
  -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt \
  cli \
  peer chaincode install \
    -n ctb \
    -v 1.0 \
    -p "github.com/chaincode/ctb" \
    -l "golang"


docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
  cli \
  peer chaincode instantiate \
    -o orderer.example.com:7050 \
    -C mychannel \
    -n ctb \
    -l "golang" \
    -v 1.0 \
    -c '{"Args":[]}' \
    -P "AND('Org1MSP.member','Org2MSP.member')" \
    --tls \
    --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
    --peerAddresses peer0.org1.example.com:7051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

docker exec \
  -e CORE_PEER_LOCALMSPID=Org1MSP \
  -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
  cli \
  peer chaincode invoke \
    -o orderer.example.com:7050 \
    -C mychannel \
    -n ctb \
    -c '{"function":"addCertificate","Args":["-----BEGIN CERTIFICATE-----\nMIIDmzCCAoMCCQDz6obA2B2drDANBgkqhkiG9w0BAQsFADCBiTELMAkGA1UEBhMC\nSU4xEjAQBgNVBAgMCU5ldyBEZWxoaTESMBAGA1UEBwwJTmV3IERlbGhpMQwwCgYD\nVQQKDANDQTIxDjAMBgNVBAsMBUFkbWluMRYwFAYDVQQDDA1hZG1pbi5jYTIuY29t\nMRwwGgYJKoZIhvcNAQkBFg1hZG1pbkBjYTIuY29tMB4XDTE4MDQxNzA1NDcyMVoX\nDTIxMDIwNDA1NDcyMVowgZQxCzAJBgNVBAYTAklOMRIwEAYDVQQIDAlOZXcgRGVs\naGkxEjAQBgNVBAcMCU5ldyBEZWxoaTEZMBcGA1UECgwQRGVsaGkgVW5pdmVyc2l0\neTEOMAwGA1UECwwFQWRtaW4xEjAQBgNVBAMMCWR1LmVkdS5pbjEeMBwGCSqGSIb3\nDQEJARYPYWRtaW5AZHUuZWR1LmluMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB\nCgKCAQEA1rewijwmODmYjMMGuBL+sEA0G2GjHVVBtp9+agxpZaI9Yc4tm2vZzCEz\ndQMQS4CoJzbA20zjsNNrrEHwKup/+OwzDpI5Lqncpvvy8qQaR5X1XJia4dJpPupd\nClkD+kmImyg2Ev5Wqwljp/oujMc9hjz55P9YuBp/vZMxLGrwdaWQXRe2/RNBHA6N\nOPn+8Kq1FoKOYNFrWcG8oHhIbph4SkAh/78YavSNU61Nq2gCN+9Z5qleU6MS0R4n\n1DWXLQ7MTY5LpJ/1N8jt+4q9ynoE9644896t9A9OEgcfW8zeWhmRsfZWpnO+1C95\nzImXJxxBlUNULmOKoPrWmzKt3QYmiQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCz\n9ibSvf6uIeQ09Ve0LFDv3UKfbweAo9YCilzu8ZCM1hmE6EMxH0AtJUEFnAqej9rN\nA1m2AoXn8zxqvQYZOUalOYmW7O85QA6zZ4XHsO5YAnYlS3zkxJ5UN2bdUyVgr9Hv\nmydY8Z13HsNloLu63E7iOQAemfRcKBKFq00NL51sGIGgTLXCN4qVpLil9iplgy7m\n3/bZFL5grIPrtuMyV7wl1gEvFoGef9Dvga1kGrmZdMkJzv4h1eMspjFhtUfOV/lc\nIY+QKXI5NSm0ihJMHAXn3MmRUS9za0IH4TSg+zJiKQQFzlCfjxzR93tr4zcOGEWn\n9aaySafV35SI798fJ0I2\n-----END CERTIFICATE-----","-----BEGIN CERTIFICATE-----\nMIIDkDCCAngCCQDJBoCV8HRlvjANBgkqhkiG9w0BAQsFADCBiTELMAkGA1UEBhMC\nSU4xEjAQBgNVBAgMCU5ldyBEZWxoaTESMBAGA1UEBwwJTmV3IERlbGhpMQwwCgYD\nVQQKDANDQTIxDjAMBgNVBAsMBUFkbWluMRYwFAYDVQQDDA1hZG1pbi5jYTIuY29t\nMRwwGgYJKoZIhvcNAQkBFg1hZG1pbkBjYTIuY29tMB4XDTE4MDQxNzA1MzUxMloX\nDTIxMDIwNDA1MzUxMlowgYkxCzAJBgNVBAYTAklOMRIwEAYDVQQIDAlOZXcgRGVs\naGkxEjAQBgNVBAcMCU5ldyBEZWxoaTEMMAoGA1UECgwDQ0EyMQ4wDAYDVQQLDAVB\nZG1pbjEWMBQGA1UEAwwNYWRtaW4uY2EyLmNvbTEcMBoGCSqGSIb3DQEJARYNYWRt\naW5AY2EyLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjdbaz+\nOnjCIMkcDqrL+lHJDE0FJ5MatWQ3METe+jpRW+vsyibU9bu3QhS7HZgH6S9//Inb\n4EUaxbTw6pKipM364gn80Dv/Jm0lStVzGy7dpMSwoTecRAEOUStIa4wEtZck3hM5\nmBz+IRFRI9WVg522aRA28GaNhcw5ZY9O0lv1RJC2BpxpqiDV0xgJ6Js7y+6VR7WC\n+QozE6S5pInCbx2gAbHqip9iIJcp7rWUgsr5HVsrxU4DybevP4E14dKrwBRje8wF\n0/I0yg7FVYRJlARRk2/hakxkceIdNGi+yZWgRqexON6cpUm1XJvZBXbxOMgZYNlt\nFd3jESGqNZlJAQcCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAaxEnwfe77jZtGIf+\n2Ecm7Qe5PdtdLOG1NvE3fnWzXF39YS8pYFX0JdcOaQRnzv261Lne4/Ca0HVL8iWP\nZOti8jMEIfQoOSAJl8VfNPft4UVT70CUGatoskILdl8YsCJUcA/7c4p0TNxPsKuU\nwtzKTWCl584ovg3VTuNMjyGz4/dsRtysGRAxdmRLCnNTqwj1CnzFZwMu3xW6Yjma\nxdK6dckOcU8QRw6K8f4mZrObzepAWjiadyiMc94jl1RPeBqhRxV0MyXJKmYcq135\nvgRLcieiEGjyuNOzoflJl7bWtseLVWfTeQdzQOA3UHCIhGI7dkTisQCvt4Pw0A1O\np+2cQw==\n-----END CERTIFICATE-----",""]}' \
    --tls \
    --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
    --peerAddresses peer0.org1.example.com:7051 \
    --peerAddresses peer1.org1.example.com:8051 \
    --peerAddresses peer0.org2.example.com:9051 \
    --peerAddresses peer1.org2.example.com:10051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt

===================================================================================================================================================================
-C mychannel -n ctb -c '{"function":"addCertificate", "Args":["-----BEGIN CERTIFICATE-----\nMIIERzCCAy+gAwIBAgIUXqWuFgy6PA6KU78P8qsLVMmwYCAwDQYJKoZIhvcNAQEL\nBQAwgZAxCzAJBgNVBAYTAlNMMRAwDgYDVQQIDAd3ZXN0ZXJuMRAwDgYDVQQHDAdj\nb2xvbWJvMRMwEQYDVQQKDApuZXctY2EgTExDMQwwCgYDVQQLDANkZXYxGTAXBgNV\nBAMMEGFkbWluLm5ldy1jYS5jb20xHzAdBgkqhkiG9w0BCQEWEGFkbWluQG5ldy1j\nYS5jb20wHhcNMTkxMTI0MTgxMjE1WhcNMjQxMTIyMTgxMjE1WjCBojELMAkGA1UE\nBhMCU0wxEDAOBgNVBAgMB3dlc3Rlcm4xEDAOBgNVBAcMB2NvbG9tYm8xFjAUBgNV\nBAoMDWZyb250bGluZSBvcmcxFzAVBgNVBAsMDnRlc3QgZnJvbnRsaW5lMRswGQYD\nVQQDDBJ0ZXN0LmZyb250bGluZS5jb20xITAfBgkqhkiG9w0BCQEWEnRlc3RAZnJv\nbnRsaW5lLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAO09RrVg\nmFmn/vguq2v5km19Nez/Ry2Fu6UbcO+ieucDYHMLfWi46aUfLI+aPO6conUQ0Zj6\noU7zdM5i9ArF0/PAmnfP/DNPLIi5yy4CR5zBXBtv1YtOMtEeJuJLDfc7AerL0Uen\nGKt+mNzW/vGM16+vsvRQENCvTS+AxRPT9RiDgaYVIyfQrtrRwMYJHLoT6IpPlzGS\nDsqPF1re5qM+jB9+Sar24t6t8OCoIK2Rq/e/8eklS/L4+5IhBtN5Pohe/9Y2HrMK\nw9DWTv5ncixi4GVdzzHF9IaHf9M+6++q0bs5xSKCeOzdJ9FZn/tII+MbQvgCW0E8\n70au1rD9PKAbQ+kCAwEAAaOBhDCBgTAfBgNVHSMEGDAWgBT3IgukZMZpV5ZY0DJA\nQ6VBTzMc8DAJBgNVHRMEAjAAMAsGA1UdDwQEAwIE8DBGBgNVHREEPzA9ghJ0ZXN0\nLmZyb250bGluZS5jb22CJ3Rlc3QuZnJvbnRsbGluZS5jb20uMTkyLjE2OC4xLjE5\nLnhpcC5pbzANBgkqhkiG9w0BAQsFAAOCAQEAIrcTYkPCtZuOjL/uw6osoyOLvvCq\nPWDmur5CPp5cZpRkQJ27OniBB4RQ3QRLGOpvFRDhRhUGqRiUHNbWOQYSJvgU3EUT\nGWYc/e1KKETpLr1uXR+WLto6eyPtQUWmTI3W89W/eN7SAogGwSwp5fNSqo5h4t5l\nfqnZYq4RrUjs5TCmv6++rLzudnfsXIQ7EkJe0YMSooYFuVvC23XgGuL6A8kpiER8\nhoktrMpKZHI+sEYaunuNusD45+TBjI4E6239d3SU2PvB1z84I3ExN6CcbKKpgAcU\n/ZNjnF9XaBjdVGuNh7giNzVmUOg+yamNFkxk2nw3hs7f1WSqWp/WVKhUbw==\n-----END CERTIFICATE-----","-----BEGIN CERTIFICATE-----\nMIIEAzCCAuugAwIBAgIUFQ7asY0VmtpOyRf+R64ahO/8LMIwDQYJKoZIhvcNAQEL\nBQAwgZAxCzAJBgNVBAYTAlNMMRAwDgYDVQQIDAd3ZXN0ZXJuMRAwDgYDVQQHDAdj\nb2xvbWJvMRMwEQYDVQQKDApuZXctY2EgTExDMQwwCgYDVQQLDANkZXYxGTAXBgNV\nBAMMEGFkbWluLm5ldy1jYS5jb20xHzAdBgkqhkiG9w0BCQEWEGFkbWluQG5ldy1j\nYS5jb20wHhcNMTkxMTI0MTgwNjA3WhcNMjQxMTIyMTgwNjA3WjCBkDELMAkGA1UE\nBhMCU0wxEDAOBgNVBAgMB3dlc3Rlcm4xEDAOBgNVBAcMB2NvbG9tYm8xEzARBgNV\nBAoMCm5ldy1jYSBMTEMxDDAKBgNVBAsMA2RldjEZMBcGA1UEAwwQYWRtaW4ubmV3\nLWNhLmNvbTEfMB0GCSqGSIb3DQEJARYQYWRtaW5AbmV3LWNhLmNvbTCCASIwDQYJ\nKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKDbxlHH63mwslsoOTo4Qva4EeBNeOYz\n5OiK0O+o0RhcBS9BMP/XLl+DJIihklF8nG6TDxGb/eC7bEkYe5gwTF22wPx7rCXB\n6vrtS4QVxloqp332CkY5+iC1DgT/B3cQR/ZGLW29mUFJM3QW1I+noFVLjt01UgY5\na3fr039hEJtpCSF9Fld3reDZma24Ke0AnK3v0vYSFO5hty2qeNI2Y/wKQJuqGCuk\npYnyLj+3c/exy3lPcssIE3p/ILz1Ug0l6j4J34d4PrBQYl+rA6OByJzQzl9m9oHa\nMEorv04SRkRI4GMFeiUwtjb2Mgvxu40nyvrCSmivcXQu3DHy5QXIZ9MCAwEAAaNT\nMFEwHQYDVR0OBBYEFPciC6RkxmlXlljQMkBDpUFPMxzwMB8GA1UdIwQYMBaAFPci\nC6RkxmlXlljQMkBDpUFPMxzwMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQEL\nBQADggEBAHvTH+p0wjqLlWfeZUBubYwgiJCSnQJVAA6Hr535WaoJmgWl72kKc4O3\nmWVeJZIH7TTTbN/dqLHwaClfbcG1tD5nyi31JnHltTovS1lsrfncfE7hlSg82WHC\npozB2DVH55I4vzGdDVNpXhuIVN/0VrOFWo+OVjIzJNHUa9h6CThKw3WNVIL9mBa2\nU0EDiaoXoqradFN4c6sT1tfGfQ7CJOxPePwUWuLPXltALLd9QiOXysZTJRngfUbr\nqBRjqGTNNNQYtdiDHav6KzSlIx6nhYUmr5D6vR+hQZuK0eml3EvU5+Sq8eeaSj1f\nlZgBDq09CaenlmZUHUg5yPgLidmm8KI=\n-----END CERTIFICATE-----",""]}'