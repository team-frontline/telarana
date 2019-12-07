'use strict';
var fs = require('fs');

const {FileSystemWallet, Gateway} = require('fabric-network');
const path = require('path');

const walletPath = path.resolve(__dirname, '..', 'library', 'hfc-key-store');
// const walletDirectoryPath = path.join(process.cwd(), 'hfc-key-store');

// Obtain the smart contract with which our application wants to interact
const wallet = new FileSystemWallet(walletPath);
// console.log(`Wallet path: ${walletPath}`);

const gatewayOptions = {wallet, identity: 'user2', discovery: {enabled: true, asLocalhost: true}};


const ccpPath = path.resolve(__dirname, '../..', 'telarana-network', 'connection-org1.json');

// console.log("ccPath is " + ccpPath); // testing

async function isUserExists() {
    // Check to see if we've already enrolled the user.
    let userExists = await wallet.exists(gatewayOptions.identity);
    if (!userExists) {
        console.log(`User '${gatewayOptions.identity}': doesn't exist`)
    } else {
        console.log(`User '${gatewayOptions.identity}': exists`)
    }
    return userExists.toString();
}

// async function gateway() {
//     // Create a new gateway for connecting to our peer node.
//     const gateway = new Gateway();
//     await gateway.connect(ccpPath, gatewayOptions);
//
//     // Get the network (channel) our contract is deployed to.
//     const network = await gateway.getNetwork('mychannel');
//     // console.log(network);
//
//     // Get the contracttermi from the network.
//     const contract = network.getContract('mschain');
//     // console.log(contract);
//     return contract;
// }

async function getHistory(subjectName, cert) {

    // Create a new gateway for connecting to our peer node.
    const gateway = new Gateway();

    try {

        await gateway.connect(ccpPath, gatewayOptions);

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');
        // console.log(network);

        // Get the contracttermi from the network.
        const contract = network.getContract('mschain');

        //get result
        const tr = await contract.evaluateTransaction('queryCertificateHistory', subjectName);

        let transactionResult = JSON.parse(tr.toString());

        let result = {
            subjectName: subjectName,
            registered: transactionResult.length > 0,
            certs: transactionResult,
        };

        console.log(result.certs);

        let data = {result, message: "<<N/A>>"};

        // console.log(`__ respond: ${JSON.stringify(data)}`);
        // console.log(`Query Result: \n${JSON.stringify(data)}`);
        console.log('\nResponse');
        console.log(data);
        return data;

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        // process.exit(1);
        // process.exit(-1);
        // let result = {subjectName: "XX", revokeStatus: "notAvailable"};
        // return JSON.parse(result.toString());

        let result = {
            subjectName: subjectName,
            registered: "<<Error>>",
            certs: "<<Error>>",
        };

        let data = {result, message: error};
        // let data = {result};

        console.log("Error getting history:", error);
        return data;

    }
    // finally {
    //     // Disconnect from the gateway
    //     console.log('Disconnect from Fabric gateway.');
    //     gateway.disconnect();
    // }
}

// isUserExists();
// evaluateCert();

module.exports = {
    isUserExists, getHistory
};

