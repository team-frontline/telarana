const express = require('express');
const router = express.Router();

var bodyParser = require('body-parser');
router.use(bodyParser.json()); // support json encoded bodies
router.use(bodyParser.urlencoded({extended: true})); // support encoded bodies

// require('library/testAction');
// import { isUserExists, evaluateCert } from "library/testAction";
const testQuery = require("../../library/testQuery");
const testAdd = require("../../library/testAdd");
const testRevoke = require("../../library/testRevoke");
const testQueryHistory = require("../../library/testQueryHistory");

router.get('/', (req, res, next) => {
    res.status(200).json({
        message: 'GET requests to /api'
    });
});

router.post('/', (req, res, next) => {
    res.status(200).json({
        message: 'POST requests to /api'
    });
});

router.get('/user-exists', async (req, res, next) => {
    res.status(200).json({
        message: 'User validated',
        payload: {user: await testQuery.isUserExists()}
    });
});

router.get('/is-alive', async (req, res, next) => {
    res.status(200).json({
        alive:true
    });
});

router.post('/get-history', async (req, res, next) => {
    let query = await testQueryHistory.getHistory(req.body.subjectName);
    res.status(200).json({
        operation: "Get History",
        status: "OK",
        data: query.result,
        message: query.message
    });
});

router.post('/eval', async (req, res, next) => {
    // console.log(req.body);

    // let subjectName = "hdworks.org";
    // let revokedStatus = "revoked";
    // let certInLedger = "-----BEGIN CERTIFICATE-----\nMIIDljCCAn4CCQDNFbionO/u5DANBgkqhkiG9w0BAQsFADCBiTELMAkGA1UEBhMC\nSU4xEjAQBgNVBAgMCU5ldyBEZWxoaTESMBAGA1UEBwwJTmV3IERlbGhpMQwwCgYD\nVQQKDANDQTIxDjAMBgNVBAsMBUFkbWluMRYwFAYDVQQDDA1hZG1pbi5jYTIuY29t\nMRwwGgYJKoZIhvcNAQkBFg1hZG1pbkBjYTIuY29tMB4XDTE4MDUwNzEzMzM1NloX\nDTIxMDIyNDEzMzM1NlowgY8xCzAJBgNVBAYTAklOMRIwEAYDVQQIDAlOZXcgRGVs\naGkxEjAQBgNVBAcMCU5ldyBEZWxoaTEQMA4GA1UECgwHaGR3b3JrczEOMAwGA1UE\nCwwFYWRtaW4xFDASBgNVBAMMC2hkd29ya3Mub3JnMSAwHgYJKoZIhvcNAQkBFhFh\nZG1pbkBoZHdvcmtzLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB\nAMbclB8bZBuEJpu1MVuvg939NsfI9UdhlAQVUHFj2GLn++H2tNJe8RDchav/Je6D\nmjSzLlt3SsuFjFnngiw1fQpB3FOkOvJulc+0GVJ7JKFILZXnO5TZOtI/PqwDwGGk\nswAXlT9mMy0I0pihNEhEMWXlM2EM+NEQRpgnjgJWRZ5nf8iG5qwqGCUDLcjhH+GO\nZ7POYLM0MZKw78myWsaXtCv/b9LKDjoWWbwqjYAhNWgVcta9OKSYDM6T0zopvDxc\nOD8vfIU0RY8pjDUCFLCKCfE/bdv2p955x6MpLJxJWN4Q4MmBk9YKOSGyMSVbLlkI\nzfmt21qIw6N3HpguN443rtECAwEAATANBgkqhkiG9w0BAQsFAAOCAQEANVIDuWjo\ne7YnmFV82Mn92+h7vDiro1MDXr8jS77TfhhFsuoUjUIaKWZRN7+aySJmeh6zITvo\nzdXa8nkAIBiE2DsiJpJD41yihIeQyleXJezIwEDzbwjo0SX1pkbpXeUs7uAt6GoN\n9sIEywNKuXOWdtK6C/f2/7HcRYMJZ1kWoXc1XYSFzemcgpI0HP3MSmh3KPVQTXsF\nObVPotZXatDqLdezsGZE+hp1oz0uRyO/C2wKikoDbUsKmBELPtjtm6o0znPRLtBY\nHlGhBZL95Znc1FdSzDEj0tlFqUDwYm9kW9K1OlbghXpqPF/xzj9ygG5MlhTYznNf\nXtQVg5VzWMrJ9A==\n-----END CERTIFICATE-----\n";
    let certStatus = await testQuery.evaluateCert(req.body.subjectName, req.body.cert);
    res.status(200).json({
        operation: "Evaluate Certificate",
        status: "OK",
        data: certStatus.result,
        sentCert:req.body.cert,
        message: certStatus.message  // message from the chaincode
    });
    // req.body.cert === certStatus.certString
});

router.post('/issue', async (req, res, next) => {

    // Template
    let issueBody = {
        "cert": "",
        "intermediateCert": "",
        "sig": ""
    };
    let revokeBody = {
        "cert": "",
        "caCert": "",
        "caSig": ""
    };

    let result = await testAdd.addCertificate(req.body.cert, req.body.intermediateCert, req.body.sig);

    res.status(200).json({
        operation: "Adding Certificate",
        // status: "OK",
        result,
        // message: {result.err}  // message from the chaincode

    });
});

router.post('/revoke', async (req, res, next) => {

    let result = await testRevoke.revokeCertificate(req.body.cert, req.body.caCert, req.body.caSig);

    res.status(200).json({
        operation: "Revoke Certificate",
        // status: "",
        result,
        // message: {result.err}  // message from the chaincode

    });
});

module.exports = router;

