;(global as any).WebSocket = require('isomorphic-ws')
const config = require('../config.js')
import { Client, KeyInfo, ThreadID, Buckets } from '@textile/hub'
import {Libp2pCryptoIdentity} from '@textile/threads-core';
import express = require('express')
const app: express.Application = express();
import * as firebase from 'firebase/app';
import "firebase/auth";
import "firebase/firestore";
import "firebase/database";
import { Request, Response } from 'express';
import { json } from 'body-parser';
const bodyParser = require('body-parser');
const Web3 = require('web3');
const axios = require('axios')
const web3 = new Web3();
const threadId = ThreadID.fromString(config.threadId)
const host = '0.0.0.0';
const port = process.env.PORT || 3000;

//app.use(bodyParser.json())
app.use(bodyParser.urlencoded({limit: '50mb',extended: true}))


var firebaseConfig = {
    apiKey: config.firebaseKey,
    authDomain: config.domain,
    databaseURL: config.dbURL,
    projectId: config.id,
    storageBucket: config.storageBucket,
    messagingSenderId: config.msgSenderId,
    appId: config.appId
  };

firebase.initializeApp(firebaseConfig);

var database = firebase.database();

const scInstance = axios.create({
    baseURL: config.Ethapi+config.contract,
    timeout: 5000,
    headers: {'X-API-KEY' : config.Ethkey}
})

//Functions Starts
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
    let mintHash = await scInstance.post('/mint', {
        account: wallet_addr,
        amount: 1000
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
    return mintHash
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
    const postID = await scInstance.get('/postCount')
    const resp = await scInstance.post('/setPublisherPurchase', {
        postId: postID.data.data[0].uint256,
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

async function hasUserPurchased(pid: any, addr: any){
    const resp = await scInstance.get('/hasUserPurchased/'+pid+'/'+addr)
    return resp.data.data[0].bool
}

async function purchasePost(pid: any, pubAddr: any, userAddr: any){
    const response = await scInstance.post('/purchasePost', {
        postId: pid,
        publisher: pubAddr,
        user: userAddr
    })
    return response
}


async function addThread(hash: any, postId: any, publisherAddr: any){
    const response = await scInstance.post('/createThread', {
        postID: postId,
        _ipfsHash: hash,
        publisher: publisherAddr
    })
    return response.data.data[0].txHash
}

async function getAllThreads(pid: any){
    const response = await scInstance.get('/getAllThreads/'+pid)                      
    return response.data.data[0]["(uint256,uint256,address,uint256,uint256,string)[]"]
}


async function upvoteThread(reqbody: any){
    const response = await scInstance.post('/upVoteThread', {
        postID: reqbody.postID,
        threadID: reqbody.threadID,
        user: reqbody.user
    }).catch((err: any) => {console.log(err.data)})
    if(response.data.success){
        return response.data.data[0].txHash
    } else {
        return false
    }
}


async function upvoteFact(reqbody: any){
    const response = await scInstance.post('/upVoteFact', {
        postID: reqbody.postID,
        user: reqbody.user
    })
    if(response.data.success){
        return response.data.data[0].txHash
    } else {
        return false
    }
}


async function donateFact(reqbody: any){
    const response = await scInstance.post('/donateToFact', {
        amount: reqbody.amount,
        from: reqbody.from,
        factId: reqbody.factId
    })
    if(response.data.success){
        return response.data.data[0].txHash
    } else {
        return false
    }

}

async function donateThread(reqbody: any){
    const response = await scInstance.post('/donateToThread', {
        amount: reqbody.amount,
        from: reqbody.from,
        factId: reqbody.factId,
        threadId: reqbody.threadId
    })
    if(response.data.success){
        return response.data.data[0].txHash
    } else {
        return false
    }
}


async function getBalance(addr: any){
    const response = await scInstance.get('/balanceOf/'+addr)
    return response.data.data[0].uint256
}


async function addBalance(addr: any, amt: any){
    const response = await scInstance.post('/mint', {
        account: addr,
        amount: amt
    })
    if(response.data.success){
        return response.data.data[0].txHash
    } else {
        return false
    }
}


//Functions End


//Routes Starts
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
    let userInfo = await getUserInfo(uid);            //Address to send to smart contract
    let postTxnId =  await createPost(postObj)         //Signing and passing to smart contract pending
                    .then(async(resp: any) => {
                        let postTxn = await pushPostId(resp, userInfo)
                                        .then((response) => {res.send({success: 'true', txnId: response, user: userInfo})})
                    })
})

app.get('/querypost/:id', async(req, res) => {
    let postId = req.params.id
    const response = await queryPost(postId)
    res.send({resp: response.data})
})

app.get('/getallposts', async(req, res) => {
    getAllPostData()
    async function getAllPosts(){
        const response = await scInstance.get('/getAllPosts')
        console.log(response.data)
        return response.data.data[0]["(uint256,address,uint256,uint256,string,(uint256,uint256,address,uint256,uint256,string)[])[]"]
    }
    
    async function getAllPostData(){
            let resp = await getAllPosts()
            //console.log(resp)
            let postIds = []
            let threads = []
            let upvotes = []
            let donations = []
            let addresses = []
            let postIndex = []
            for(let i=0 ; i<resp.length ; i++){
                postIds.push(resp[i][4])
                threads.push(resp[i][5])
                upvotes.push(resp[i][3])
                donations.push(resp[i][2])
                addresses.push(resp[i][1])
                postIndex.push(resp[i][0])
            }
            getPostsData(postIds, threads, upvotes, donations, addresses, postIndex)
        
    }
    
    async function getPostsData(ids: any, threads: any, upvotes: any, donations: any, addresses: any, postIndex: any){
        const auth: KeyInfo = {
            key: 'blyygdhgn5thkwyugov2g5gjxdu',
            secret: ''
          }
        const client = await Client.withKeyInfo(auth)
        let posts = new Array()
        for(let x = 0; x<ids.length; x++){
            let resp = await client.findByID(threadId, 'Posts', ids[x])
            resp.instance['postId'] = postIndex[x]
            resp.instance['threads'] = threads[x]
            resp.instance['upvotes'] = upvotes[x]
            resp.instance['donations'] = donations[x]
            resp.instance['user'] = addresses[x]
            posts.push(resp.instance)
        }
        res.send(posts)
    }
})

app.get('/haspurchased/:pid/:uid', async(req, res) => {
    const pid = req.params.pid
    const uid = req.params.uid
    const useraddr = await getUserInfo(uid)
    hasUserPurchased(pid, useraddr)
        .then((response) => {
            res.send(response)
        })
})


app.post('/purchasePost/:uid', async(req, res) => {
    const pid = req.body.postId
    const pubAddr = req.body.publisherAddress
    const userAddr = await getUserInfo(req.params.uid)
    purchasePost(pid, pubAddr, userAddr)
        .then((response) => {
            if(response.data.success){
                res.send({success: 'true', txHash: response.data.data[0].txHash})
            } else {
                res.send({success: 'false', errorMessage: 'Some error has occured, also make sure you have enough balance'})
            }
        })
})


app.post('/createthread/:pid/:uid', async(req, res) => {
    const postId = req.params.pid
    const userAddr = await getUserInfo(req.params.uid)
    const thread = {
        title: req.body.title,
        image: req.body.image,
        content: req.body.content
    }
    let post = await createPost(thread)
                .then(async(resp) => {
                    const threadHash = await addThread(resp,postId,userAddr)
                    res.send({success: 'true', postID: postId, threadTxHash: threadHash})
                })
})

app.post('/upvotefact/:pid/:uid', async(req, res) => {
    const postId = req.params.pid
    const userAddr = await getUserInfo(req.params.uid)
    const reqbody = {
        postID: postId,
        user: userAddr
    }
    const resp = await upvoteFact(reqbody)
    if(!resp) {
        res.send({success: false, err: 'Something went wrong'})
    } else {
        res.send({success: true, txHash: resp})
    }
})

app.post('/upvotethread/:pid/:tid/:uid', async(req, res) => {
    const postId = req.params.pid
    const threadId = req.params.tid
    const userAddr = await getUserInfo(req.params.uid)
    const reqbody = {
        postID: postId,
        threadID: threadId,
        user: userAddr
    }
    console.log(reqbody)
    const resp = await upvoteThread(reqbody)
    if(!resp) {
        res.send({success: false, err: 'Something went wrong'})
    } else {
        res.send({success: true, txHash: resp})
    }
})


app.get('/getallthreads/:pid', async(req, res) => {
    const postId = req.params.pid
    const arr = await getAllThreads(postId)
    let threadHash = []
    let threadIds = []
    let postIds = []
    let publisherAddresses = []
    let donations = []
    let upvotes = []

    for(let i = 0; i<arr.length; i++){
        threadIds.push(arr[i][0])
        postIds.push(arr[i][1])
        publisherAddresses.push(arr[i][2])
        donations.push(arr[i][3])
        upvotes.push(arr[i][4])
        threadHash.push(arr[i][5])
    }
    getAllThreadsData(threadHash,threadIds, postIds, publisherAddresses,donations,upvotes)

    async function getAllThreadsData(threadHash: any, threadIds: any, postIds: any, publisherAddr: any, donations: any, upvotes: any){
        const auth: KeyInfo = {
            key: 'blyygdhgn5thkwyugov2g5gjxdu',
            secret: ''
          }
        const client = await Client.withKeyInfo(auth)
        let threads = new Array()
        for(let x = 0; x<threadHash.length; x++){
            let resp = await client.findByID(threadId, 'Posts', threadHash[x])
            resp.instance['postId'] = postIds[x]
            resp.instance['threadId'] = threadIds[x]
            resp.instance['upvotes'] = upvotes[x]
            resp.instance['donations'] = donations[x]
            resp.instance['publisher'] = publisherAddr[x]
            threads.push(resp.instance)
        }
        res.send(threads)
    }
})

app.post('/donatetofact/:pid/:uid', async(req, res) => {
    const postId = parseInt(req.params.pid)
    const userAddr = await getUserInfo(req.params.uid)
    const Amount = parseInt(req.body.amount)
    const reqbody = {
        amount: Amount,
        from: userAddr,
        factId: postId
    }
    const resp = await donateFact(reqbody)
    if(!resp){
        res.send({success: false, error: 'Something went wront'})
    } else {
        res.send({success: true, txHash: resp})
    }
})


app.post('/donatetothread/:pid/:tid/:uid', async(req, res) => {
    const postId = req.params.pid
    const ThreadId = req.params.tid
    const userAddr = await getUserInfo(req.params.uid)
    const Amount = req.body.amount
    const reqbody = {
        amount: Amount,
        from: userAddr,
        factId: postId,
        threadId: ThreadId
    }
    const resp = await donateThread(reqbody)
    if(!resp){
        res.send({success: false, error: 'Something went wront'})
    } else {
        res.send({success: true, txHash: resp})
    }
})

app.get('/getaccountdetails/:uid', async(req, res) => {
    const userAddr = await getUserInfo(req.params.uid)
    const balance = await getBalance(userAddr)
    res.send({userAddress: userAddr, balance: balance})
})


app.post('/buytokens/:uid', async(req, res) => {
    const userAddr = await getUserInfo(req.params.uid)
    const amount = req.body.amount
    const resp = await addBalance(userAddr, amount)
    if(!resp){
        res.send({success: false, error: 'Something went wrong'})
    } else {
        res.send({success: true, txHash: resp})
    }
})
//Routes End



app.listen(process.env.PORT || 5000, () => {console.log("server running port 3000")})

