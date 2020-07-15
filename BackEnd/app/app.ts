;(global as any).WebSocket = require('isomorphic-ws')
import { Client, KeyInfo, ThreadID, Buckets } from '@textile/hub'
import {Libp2pCryptoIdentity} from '@textile/threads-core';
import express = require('express')
const app: express.Application = express();
import * as firebase from 'firebase/app';
import "firebase/auth";
import "firebase/firestore";
import "firebase/database";
const bodyParser = require('body-parser');
const Web3 = require('web3');
const axios = require('axios')
let web3provider = 'https://goerli.infura.io/v3/ee0e744e0cfe471ab09c8ef8efa2b08f'
const web3 = new Web3(new Web3.providers.HttpProvider(web3provider));
const threadId = ThreadID.fromString('bafkwf6lewg4eaodvqms5feq35lqik4bydfswx3722qz2ltqzy3qopka')

app.use(bodyParser.json())

const firebaseConfig = {
    apiKey: "AIzaSyDYyGjn_9ToO7F1y9QnXzQN8tkHON3xRbM",
    authDomain: "facts-hackfs.firebaseapp.com",
    databaseURL: "https://facts-hackfs.firebaseio.com",
    projectId: "facts-hackfs",
    storageBucket: "facts-hackfs.appspot.com",
    messagingSenderId: "638386091930",
    appId: "1:638386091930:web:313e85db2e47761b362c23"
  };

firebase.initializeApp(firebaseConfig);

var database = firebase.database();

const ercInstance = axios.create({
    baseURL: 'https://beta-api.ethvigil.com/v0.1/contract/0x5a91e18c458e21afd7fc2051168484598c59d3e7',
    timeout: 5000,
    headers: {'X-API-KEY': 'c6cde06b-d6d3-4c10-9007-e6f6074c6983'}
})

const scInstance = axios.create({
    baseURL: 'https://beta-api.ethvigil.com/v0.1/contract/',
    timeout: 5000,
    headers: {'X-API-KEY' : 'c6cde06b-d6d3-4c10-9007-e6f6074c6983'}
})

async function createUser (uid: any) {
    const identityKey = await generateIdentityKey()
    const ethAccount = await createEthereumAccount()
    firebase.database().ref('users/'+uid).set({
        identityKey: identityKey,
        publicKey: ethAccount.address,
        privateKey: ethAccount.privateKey
    })
    return ethAccount.address
}

async function signup_mint(wallet_addr: any) {
    ercInstance.post('/mint', {
        account: wallet_addr,
        amount: 1000
    })
    .then((response:any) => {
        console.log(response.data)
        return response.data
    })
    .catch((error:any) => {
        if (error.response.data){
			console.log(error.response.data);
			if (error.response.data.error == 'unknown contract'){
				console.error('You filled in the wrong contract address!');
			}
		} else {
			console.log(error.response);
		}
		process.exit(0);
    });
}

async function generateIdentityKey () {
    const identity = await Libp2pCryptoIdentity.fromRandom()
    const identityString = identity.toString()
    return identityString
 }

async function createEthereumAccount(){
    let account = web3.eth.accounts.create()
    return account
}


async function createPost (post: JSON) {
    const auth: KeyInfo = {
      key: 'blyygdhgn5thkwyugov2g5gjxdu',
      secret: ''
    }
    const client = await Client.withKeyInfo(auth)
    const resp = await client.create(threadId, 'Posts', [post])
    return resp[0]
  }

async function pushPostId(id: any, publisherAddress: any) {
    scInstance.post('/createPost', {
        _ipfsHash: id,
        publisher: publisherAddress
    })
    .then((response: any) => {
        return response.data
    })
}

async function getUserInfo(uid: any){
    firebase.database().ref('/users').child(uid).once('value').then(snapshot => {
        const details = snapshot.val()
        return details.address
    })
}


app.get('/generatekeys/:id',(req, res) => {
    let UserId = req.params.id;
    const ethAddress = createUser(UserId)
    const mintTxHash = signup_mint(ethAddress)
    res.send({success: true, ethAddress: ethAddress, signUpHash: mintTxHash})
})

app.post('/addpost/:id', async (req, res) => {
    let post = req.body
    let uid = req.params.id
    const postID = await createPost(post)         //Signing and passing to smart contract pending
    let userInfo = await getUserInfo(uid);            //Address to send to smart contract
    let postTxn = await pushPostId(postID, userInfo)
    res.send({success: 'true', postTxnID: postTxn})
})


app.listen(3000, () => {console.log("server running port 3000")})

