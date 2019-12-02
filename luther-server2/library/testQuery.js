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

async function evaluateCert(subjectName, cert) {

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
        const tr = await contract.evaluateTransaction('queryCertificate', subjectName);
        //     .catch((e) => {
        //     console.log('\n\n Error (starts from here))');
        //     let result = {
        //         subjectName: "<<Not Found>>",
        //         validity: false,
        //         revokeStatus: "<<N/A>>",
        //         certString: "<<N/A>>",
        //     };
        //
        //     // let data = {result, message: e};
        //     let data = {result};
        //
        //     console.log(`NOT FOUND\n respond: ${JSON.stringify(data)}`);
        //     // console.log(e);
        //     return data;
        // });

        let transactionResult = JSON.parse(tr.toString());

        let result = {
            subjectName: transactionResult.subjectName,
            validity: cert == transactionResult.certString,
            revokeStatus: transactionResult.revokeStatus,
            certString: transactionResult.certString,
        };

        let data = {result, message: "<<N/A>>"};

        // console.log(`__ respond: ${JSON.stringify(data)}`);
        // console.log(`Transaction has been evaluated, result is: ${JSON.stringify(data)}`);
        return data;


    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        // process.exit(1);
        // process.exit(-1);
        // let result = {subjectName: "XX", revokeStatus: "notAvailable"};
        // return JSON.parse(result.toString());

        let result = {
            subjectName: "<<Not Found>>",
            validity: false,
            revokeStatus: "<<N/A>>",
            certString: "<<N/A>>",
        };

        let data = {result, message: error};
        // let data = {result};

        console.log(`NOT FOUND\n respond: ${JSON.stringify(data)}`);
        console.log(error);
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
    isUserExists, evaluateCert
};

