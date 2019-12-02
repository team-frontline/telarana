/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';
var fs = require('fs');

const { FileSystemWallet, Gateway } = require('fabric-network');
const path = require('path');

const ccpPath =  path.resolve(__dirname, '..', 'telarana-network', 'connection-org1.json');

async function main() {
    try {

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'hfc-key-store');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists('user1');
        if (!userExists) {
            console.log('An identity for the user "user1" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }else{
            console.log("user exists");
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccpPath, { wallet, identity: 'user1', discovery: { enabled: true, asLocalhost: true } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('mschain');

        var certPath = "certificates/CA2/hdworks/hdworks.pem"; //proposed certificate
        var intermediateCertPath ="certificates/CA2/CA2.pem"; //certificate authority's root certificate
        var certString = fs.readFileSync(certPath).toString();
        var intermediateCertString = fs.readFileSync(intermediateCertPath).toString();
        var sigString = "";
        await contract.submitTransaction('addCertificate',certString,intermediateCertString,sigString);

        // contract.submitTransaction('addCertificate',certString,intermediateCertString,sigString).then((buffter)=>{
        //     console.log(buffter);
        // })
        // .catch((err)=>{
        //     console.log("error::",err);
        // });
    

        // Disconnect from the gateway.
        await gateway.disconnect();

    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        process.exit(1);
    }
}

main();
