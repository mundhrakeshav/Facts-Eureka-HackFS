;(global as any).WebSocket = require('isomorphic-ws')
import { Client, KeyInfo, ThreadID, Buckets } from '@textile/hub'
import {Libp2pCryptoIdentity} from '@textile/threads-core';
import express = require('express')
const app: express.Application = express();
import * as firebase from 'firebase/app';
import "firebase/auth";
import "firebase/firestore";
import "firebase/database";
import { Request, Response } from 'express';
const bodyParser = require('body-parser');
const Web3 = require('web3');
const axios = require('axios')
let web3provider = 'https://goerli.infura.io/v3/ee0e744e0cfe471ab09c8ef8efa2b08f'
const web3 = new Web3(new Web3.providers.HttpProvider(web3provider));
const threadId = ThreadID.fromString('bafkwf6lewg4eaodvqms5feq35lqik4bydfswx3722qz2ltqzy3qopka')

//app.use(bodyParser.json())
app.use(bodyParser.urlencoded({limit: '50mb',extended: true}))


var firebaseConfig = {
    apiKey: "AIzaSyA3PZyMpVFpvKoCX0soSrXEn3GYa4DEAxI",
    authDomain: "facts-fa7a1.firebaseapp.com",
    databaseURL: "https://facts-fa7a1.firebaseio.com",
    projectId: "facts-fa7a1",
    storageBucket: "facts-fa7a1.appspot.com",
    messagingSenderId: "788183696859",
    appId: "1:788183696859:web:7f22a930afd231c17613fe"
  };

firebase.initializeApp(firebaseConfig);

var database = firebase.database();

const ercInstance = axios.create({
    baseURL: 'https://beta-api.ethvigil.com/v0.1/contract/0xad62722dba0857a2637bffaaade855773ded78f9',
    timeout: 5000,
    headers: {'X-API-KEY': 'c6cde06b-d6d3-4c10-9007-e6f6074c6983'}
})

const scInstance = axios.create({
    baseURL: 'https://beta-api.ethvigil.com/v0.1/contract/0xad62722dba0857a2637bffaaade855773ded78f9',
    timeout: 5000,
    headers: {'X-API-KEY' : 'c6cde06b-d6d3-4c10-9007-e6f6074c6983'}
})

 async   function createUser ( uid: any) {
    const identityKey = await generateIdentityKey()
    const ethAccount = await createEthereumAccount()
    firebase.database().ref('users/'+uid).set({
        identityKey: identityKey,
        publicKey: ethAccount.address,
        privateKey: ethAccount.privateKey
    })
    const mintTxHash = signup_mint(ethAccount.address)
    console.log(mintTxHash)
}

async function queryPost( postId: any ){
    let resp = await scInstance.get('/facts/'+postId )
    return resp
}

async function signup_mint(wallet_addr: any) {
    ercInstance.post('/mint', {
        account: wallet_addr,
        amount: 1000
    })
    .then((response:any) => {
        console.log(response.data)
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


async function createPost (post: any) {
    const auth: KeyInfo = {
      key: 'blyygdhgn5thkwyugov2g5gjxdu',
      secret: ''
    }
    const client = await Client.withKeyInfo(auth)
    const resp = await client.create(threadId, 'Posts', [post])
    return resp[0]
  }

async function pushPostId(id: any, publisherAddress: any) {
    const response = await scInstance.post('/createPost', {
        _ipfsHash: id,
        publisher: publisherAddress
    })
    return response.data.data[0].txHash
}

async function getUserInfo(uid: any){
    const addr = await firebase.database().ref('/users').child(uid).once('value').then(snapshot => {
        const details = snapshot.val()
        return details.publicKey
    })
    return addr
}


app.get('/generatekeys/:id',(req, res) => {
    let UserId = req.params.id;
    const ethAddress = createUser(UserId)
})

app.post('/addpost/:id', async (req, res) => {
    let Btitle = req.body.title
    let Bcontent = req.body.content
    let uid = req.params.id
    let Bimage = req.body.image
    const postObj = {
        title: Btitle,
        content: Bcontent,
        image: Bimage
    }
    console.log(postObj)
    let userInfo = await getUserInfo(uid);            //Address to send to smart contract
    let postTxnId =  await createPost(postObj)         //Signing and passing to smart contract pending
                    .then(async(resp: any) => {
                        let postTxn = await pushPostId(resp, userInfo)
                                        .then(() => {res.send({success: 'true', txnId: postTxn})})
                    })
})

app.get('/querypost/:id', async(req, res) => {
    let postId = req.params.id
    const response = await queryPost(postId)
    console.log(response.data)
    res.send({resp: response.data})
})


app.listen(3000, () => {console.log("server running port 3000")})

