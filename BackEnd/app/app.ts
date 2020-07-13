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
const Web3 = require('web3')
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

async function createUser (uid: any) {
    const identityKey = await generateIdentityKey()
    const ethAccount = await createEthereumAccount()
    firebase.database().ref('users/'+uid).set({
        identityKey: identityKey,
        publicKey: ethAccount.address,
        privateKey: ethAccount.privateKey
    })
    return true
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

async function getUserInfo(uid: any){
    firebase.database().ref('/users').child(uid).once('value').then(snapshot => {
        const details = snapshot.val()
        return details
    })
}


app.get('/generatekeys/:id',(req, res) => {
    let UserId = req.params.id;
    const resp = createUser(UserId)
    res.send({result: resp})
})

app.post('/addpost/:id', async (req, res) => {
    let post = req.body
    let uid = req.params.id
    const postID = await createPost(post)         //Signing and passing to smart contract pending
    let userInfo = getUserInfo(uid);              //Address to send to smart contract
    res.send({postID: postID})
})


app.listen(3000, () => {console.log("server running port 3000")})

