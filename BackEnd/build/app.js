"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
Object.defineProperty(exports, "__esModule", { value: true });
;
global.WebSocket = require('isomorphic-ws');
var config = require('../config.js');
var hub_1 = require("@textile/hub");
var threads_core_1 = require("@textile/threads-core");
var express = require("express");
var app = express();
var firebase = __importStar(require("firebase/app"));
require("firebase/auth");
require("firebase/firestore");
require("firebase/database");
var bodyParser = require('body-parser');
var Web3 = require('web3');
var axios = require('axios');
var web3 = new Web3();
var threadId = hub_1.ThreadID.fromString(config.threadId);
var host = '0.0.0.0';
var port = process.env.PORT || 3000;
//app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));
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
var scInstance = axios.create({
    baseURL: config.Ethapi + config.contract,
    timeout: 5000,
    headers: { 'X-API-KEY': config.Ethkey }
});
//Functions Starts
function createUser(uid) {
    return __awaiter(this, void 0, void 0, function () {
        var identityKey, ethAccount, mintTxHash;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, generateIdentityKey()];
                case 1:
                    identityKey = _a.sent();
                    return [4 /*yield*/, createEthereumAccount()];
                case 2:
                    ethAccount = _a.sent();
                    firebase.database().ref('users/' + uid).set({
                        identityKey: identityKey,
                        publicKey: ethAccount.address,
                        privateKey: ethAccount.privateKey
                    });
                    mintTxHash = signup_mint(ethAccount.address);
                    console.log(mintTxHash);
                    return [2 /*return*/];
            }
        });
    });
}
function queryPost(postId) {
    return __awaiter(this, void 0, void 0, function () {
        var resp;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.get('/facts/' + postId)];
                case 1:
                    resp = _a.sent();
                    return [2 /*return*/, resp];
            }
        });
    });
}
function signup_mint(wallet_addr) {
    return __awaiter(this, void 0, void 0, function () {
        var mintHash;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.post('/mint', {
                        account: wallet_addr,
                        amount: 1000
                    })
                        .catch(function (error) {
                        if (error.response.data) {
                            console.log(error.response.data);
                            if (error.response.data.error == 'unknown contract') {
                                console.error('You filled in the wrong contract address!');
                            }
                        }
                        else {
                            console.log(error.response);
                        }
                        process.exit(0);
                    })];
                case 1:
                    mintHash = _a.sent();
                    return [2 /*return*/, mintHash];
            }
        });
    });
}
function generateIdentityKey() {
    return __awaiter(this, void 0, void 0, function () {
        var identity, identityString;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, threads_core_1.Libp2pCryptoIdentity.fromRandom()];
                case 1:
                    identity = _a.sent();
                    identityString = identity.toString();
                    return [2 /*return*/, identityString];
            }
        });
    });
}
function createEthereumAccount() {
    return __awaiter(this, void 0, void 0, function () {
        var account;
        return __generator(this, function (_a) {
            account = web3.eth.accounts.create();
            return [2 /*return*/, account];
        });
    });
}
function createPost(post) {
    return __awaiter(this, void 0, void 0, function () {
        var auth, client, resp;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    auth = {
                        key: 'blyygdhgn5thkwyugov2g5gjxdu',
                        secret: ''
                    };
                    return [4 /*yield*/, hub_1.Client.withKeyInfo(auth)];
                case 1:
                    client = _a.sent();
                    return [4 /*yield*/, client.create(threadId, 'Posts', [post])];
                case 2:
                    resp = _a.sent();
                    return [2 /*return*/, resp[0]];
            }
        });
    });
}
function pushPostId(id, publisherAddress) {
    return __awaiter(this, void 0, void 0, function () {
        var response, postID, resp;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.post('/createPost', {
                        _ipfsHash: id,
                        publisher: publisherAddress
                    })];
                case 1:
                    response = _a.sent();
                    return [4 /*yield*/, scInstance.get('/postCount')];
                case 2:
                    postID = _a.sent();
                    return [4 /*yield*/, scInstance.post('/setPublisherPurchase', {
                            postId: postID.data.data[0].uint256,
                            publisher: publisherAddress
                        })];
                case 3:
                    resp = _a.sent();
                    return [2 /*return*/, response.data.data[0].txHash];
            }
        });
    });
}
function getUserInfo(uid) {
    return __awaiter(this, void 0, void 0, function () {
        var addr;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, firebase.database().ref('/users').child(uid).once('value').then(function (snapshot) {
                        var details = snapshot.val();
                        return details.publicKey;
                    })];
                case 1:
                    addr = _a.sent();
                    return [2 /*return*/, addr];
            }
        });
    });
}
function hasUserPurchased(pid, addr) {
    return __awaiter(this, void 0, void 0, function () {
        var resp;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.get('/hasUserPurchased/' + pid + '/' + addr)];
                case 1:
                    resp = _a.sent();
                    return [2 /*return*/, resp.data.data[0].bool];
            }
        });
    });
}
function purchasePost(pid, pubAddr, userAddr) {
    return __awaiter(this, void 0, void 0, function () {
        var response;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.post('/purchasePost', {
                        postId: pid,
                        publisher: pubAddr,
                        user: userAddr
                    })];
                case 1:
                    response = _a.sent();
                    return [2 /*return*/, response];
            }
        });
    });
}
function addThread(hash, postId, publisherAddr) {
    return __awaiter(this, void 0, void 0, function () {
        var response;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.post('/createThread', {
                        postID: postId,
                        _ipfsHash: hash,
                        publisher: publisherAddr
                    })];
                case 1:
                    response = _a.sent();
                    return [2 /*return*/, response.data.data[0].txHash];
            }
        });
    });
}
function getAllThreads(pid) {
    return __awaiter(this, void 0, void 0, function () {
        var response;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.get('/getAllThreads/' + pid)];
                case 1:
                    response = _a.sent();
                    return [2 /*return*/, response.data.data[0]["(uint256,uint256,address,uint256,uint256,string)[]"]];
            }
        });
    });
}
function upvoteThread(reqbody) {
    return __awaiter(this, void 0, void 0, function () {
        var response;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.post('/upVoteThread', {
                        postID: reqbody.postID,
                        threadID: reqbody.threadID,
                        user: reqbody.user
                    }).catch(function (err) { console.log(err.data); })];
                case 1:
                    response = _a.sent();
                    if (response.data.success) {
                        return [2 /*return*/, response.data.data[0].txHash];
                    }
                    else {
                        return [2 /*return*/, false];
                    }
                    return [2 /*return*/];
            }
        });
    });
}
function upvoteFact(reqbody) {
    return __awaiter(this, void 0, void 0, function () {
        var response;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.post('/upVoteFact', {
                        postID: reqbody.postID,
                        user: reqbody.user
                    })];
                case 1:
                    response = _a.sent();
                    if (response.data.success) {
                        return [2 /*return*/, response.data.data[0].txHash];
                    }
                    else {
                        return [2 /*return*/, false];
                    }
                    return [2 /*return*/];
            }
        });
    });
}
function donateFact(reqbody) {
    return __awaiter(this, void 0, void 0, function () {
        var response;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.post('/donateToFact', {
                        amount: reqbody.amount,
                        from: reqbody.from,
                        factId: reqbody.factId
                    })];
                case 1:
                    response = _a.sent();
                    if (response.data.success) {
                        return [2 /*return*/, response.data.data[0].txHash];
                    }
                    else {
                        return [2 /*return*/, false];
                    }
                    return [2 /*return*/];
            }
        });
    });
}
function donateThread(reqbody) {
    return __awaiter(this, void 0, void 0, function () {
        var response;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.post('/donateToThread', {
                        amount: reqbody.amount,
                        from: reqbody.from,
                        factId: reqbody.factId,
                        threadId: reqbody.threadId
                    })];
                case 1:
                    response = _a.sent();
                    if (response.data.success) {
                        return [2 /*return*/, response.data.data[0].txHash];
                    }
                    else {
                        return [2 /*return*/, false];
                    }
                    return [2 /*return*/];
            }
        });
    });
}
function getBalance(addr) {
    return __awaiter(this, void 0, void 0, function () {
        var response;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.get('/balanceOf/' + addr)];
                case 1:
                    response = _a.sent();
                    return [2 /*return*/, response.data.data[0].uint256];
            }
        });
    });
}
function addBalance(addr, amt) {
    return __awaiter(this, void 0, void 0, function () {
        var response;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0: return [4 /*yield*/, scInstance.post('/mint', {
                        account: addr,
                        amount: amt
                    })];
                case 1:
                    response = _a.sent();
                    if (response.data.success) {
                        return [2 /*return*/, response.data.data[0].txHash];
                    }
                    else {
                        return [2 /*return*/, false];
                    }
                    return [2 /*return*/];
            }
        });
    });
}
//Functions End
//Routes Starts
app.get('/generatekeys/:id', function (req, res) {
    var UserId = req.params.id;
    var ethAddress = createUser(UserId);
});
app.post('/addpost/:id', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var Btitle, Bcontent, uid, Bimage, postObj, userInfo, postTxnId;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                Btitle = req.body.title;
                Bcontent = req.body.content;
                uid = req.params.id;
                Bimage = req.body.image;
                postObj = {
                    title: Btitle,
                    content: Bcontent,
                    image: Bimage
                };
                return [4 /*yield*/, getUserInfo(uid)];
            case 1:
                userInfo = _a.sent();
                return [4 /*yield*/, createPost(postObj) //Signing and passing to smart contract pending
                        .then(function (resp) { return __awaiter(void 0, void 0, void 0, function () {
                        var postTxn;
                        return __generator(this, function (_a) {
                            switch (_a.label) {
                                case 0: return [4 /*yield*/, pushPostId(resp, userInfo)
                                        .then(function (response) { res.send({ success: 'true', txnId: response, user: userInfo }); })];
                                case 1:
                                    postTxn = _a.sent();
                                    return [2 /*return*/];
                            }
                        });
                    }); })];
            case 2:
                postTxnId = _a.sent();
                return [2 /*return*/];
        }
    });
}); });
app.get('/querypost/:id', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var postId, response;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                postId = req.params.id;
                return [4 /*yield*/, queryPost(postId)];
            case 1:
                response = _a.sent();
                res.send({ resp: response.data });
                return [2 /*return*/];
        }
    });
}); });
app.get('/getallposts', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    function getAllPosts() {
        return __awaiter(this, void 0, void 0, function () {
            var response;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, scInstance.get('/getAllPosts')];
                    case 1:
                        response = _a.sent();
                        console.log(response.data);
                        return [2 /*return*/, response.data.data[0]["(uint256,address,uint256,uint256,string,(uint256,uint256,address,uint256,uint256,string)[])[]"]];
                }
            });
        });
    }
    function getAllPostData() {
        return __awaiter(this, void 0, void 0, function () {
            var resp, postIds, threads, upvotes, donations, addresses, postIndex, i;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, getAllPosts()
                        //console.log(resp)
                    ];
                    case 1:
                        resp = _a.sent();
                        postIds = [];
                        threads = [];
                        upvotes = [];
                        donations = [];
                        addresses = [];
                        postIndex = [];
                        for (i = 0; i < resp.length; i++) {
                            postIds.push(resp[i][4]);
                            threads.push(resp[i][5]);
                            upvotes.push(resp[i][3]);
                            donations.push(resp[i][2]);
                            addresses.push(resp[i][1]);
                            postIndex.push(resp[i][0]);
                        }
                        getPostsData(postIds, threads, upvotes, donations, addresses, postIndex);
                        return [2 /*return*/];
                }
            });
        });
    }
    function getPostsData(ids, threads, upvotes, donations, addresses, postIndex) {
        return __awaiter(this, void 0, void 0, function () {
            var auth, client, posts, x, resp;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        auth = {
                            key: 'blyygdhgn5thkwyugov2g5gjxdu',
                            secret: ''
                        };
                        return [4 /*yield*/, hub_1.Client.withKeyInfo(auth)];
                    case 1:
                        client = _a.sent();
                        posts = new Array();
                        x = 0;
                        _a.label = 2;
                    case 2:
                        if (!(x < ids.length)) return [3 /*break*/, 5];
                        return [4 /*yield*/, client.findByID(threadId, 'Posts', ids[x])];
                    case 3:
                        resp = _a.sent();
                        resp.instance['postId'] = postIndex[x];
                        resp.instance['threads'] = threads[x];
                        resp.instance['upvotes'] = upvotes[x];
                        resp.instance['donations'] = donations[x];
                        resp.instance['user'] = addresses[x];
                        posts.push(resp.instance);
                        _a.label = 4;
                    case 4:
                        x++;
                        return [3 /*break*/, 2];
                    case 5:
                        res.send(posts);
                        return [2 /*return*/];
                }
            });
        });
    }
    return __generator(this, function (_a) {
        getAllPostData();
        return [2 /*return*/];
    });
}); });
app.get('/haspurchased/:pid/:uid', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var pid, uid, useraddr;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                pid = req.params.pid;
                uid = req.params.uid;
                return [4 /*yield*/, getUserInfo(uid)];
            case 1:
                useraddr = _a.sent();
                hasUserPurchased(pid, useraddr)
                    .then(function (response) {
                    res.send(response);
                });
                return [2 /*return*/];
        }
    });
}); });
app.post('/purchasePost/:uid', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var pid, pubAddr, userAddr;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                pid = req.body.postId;
                pubAddr = req.body.publisherAddress;
                return [4 /*yield*/, getUserInfo(req.params.uid)];
            case 1:
                userAddr = _a.sent();
                purchasePost(pid, pubAddr, userAddr)
                    .then(function (response) {
                    if (response.data.success) {
                        res.send({ success: 'true', txHash: response.data.data[0].txHash });
                    }
                    else {
                        res.send({ success: 'false', errorMessage: 'Some error has occured, also make sure you have enough balance' });
                    }
                });
                return [2 /*return*/];
        }
    });
}); });
app.post('/createthread/:pid/:uid', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var postId, userAddr, thread, post;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                postId = req.params.pid;
                return [4 /*yield*/, getUserInfo(req.params.uid)];
            case 1:
                userAddr = _a.sent();
                thread = {
                    title: req.body.title,
                    image: req.body.image,
                    content: req.body.content
                };
                return [4 /*yield*/, createPost(thread)
                        .then(function (resp) { return __awaiter(void 0, void 0, void 0, function () {
                        var threadHash;
                        return __generator(this, function (_a) {
                            switch (_a.label) {
                                case 0: return [4 /*yield*/, addThread(resp, postId, userAddr)];
                                case 1:
                                    threadHash = _a.sent();
                                    res.send({ success: 'true', postID: postId, threadTxHash: threadHash });
                                    return [2 /*return*/];
                            }
                        });
                    }); })];
            case 2:
                post = _a.sent();
                return [2 /*return*/];
        }
    });
}); });
app.post('/upvotefact/:pid/:uid', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var postId, userAddr, reqbody, resp;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                postId = req.params.pid;
                return [4 /*yield*/, getUserInfo(req.params.uid)];
            case 1:
                userAddr = _a.sent();
                reqbody = {
                    postID: postId,
                    user: userAddr
                };
                return [4 /*yield*/, upvoteFact(reqbody)];
            case 2:
                resp = _a.sent();
                if (!resp) {
                    res.send({ success: false, err: 'Something went wrong' });
                }
                else {
                    res.send({ success: true, txHash: resp });
                }
                return [2 /*return*/];
        }
    });
}); });
app.post('/upvotethread/:pid/:tid/:uid', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var postId, threadId, userAddr, reqbody, resp;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                postId = req.params.pid;
                threadId = req.params.tid;
                return [4 /*yield*/, getUserInfo(req.params.uid)];
            case 1:
                userAddr = _a.sent();
                reqbody = {
                    postID: postId,
                    threadID: threadId,
                    user: userAddr
                };
                console.log(reqbody);
                return [4 /*yield*/, upvoteThread(reqbody)];
            case 2:
                resp = _a.sent();
                if (!resp) {
                    res.send({ success: false, err: 'Something went wrong' });
                }
                else {
                    res.send({ success: true, txHash: resp });
                }
                return [2 /*return*/];
        }
    });
}); });
app.get('/getallthreads/:pid', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    function getAllThreadsData(threadHash, threadIds, postIds, publisherAddr, donations, upvotes) {
        return __awaiter(this, void 0, void 0, function () {
            var auth, client, threads, x, resp;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        auth = {
                            key: 'blyygdhgn5thkwyugov2g5gjxdu',
                            secret: ''
                        };
                        return [4 /*yield*/, hub_1.Client.withKeyInfo(auth)];
                    case 1:
                        client = _a.sent();
                        threads = new Array();
                        x = 0;
                        _a.label = 2;
                    case 2:
                        if (!(x < threadHash.length)) return [3 /*break*/, 5];
                        return [4 /*yield*/, client.findByID(threadId, 'Posts', threadHash[x])];
                    case 3:
                        resp = _a.sent();
                        resp.instance['postId'] = postIds[x];
                        resp.instance['threadId'] = threadIds[x];
                        resp.instance['upvotes'] = upvotes[x];
                        resp.instance['donations'] = donations[x];
                        resp.instance['publisher'] = publisherAddr[x];
                        threads.push(resp.instance);
                        _a.label = 4;
                    case 4:
                        x++;
                        return [3 /*break*/, 2];
                    case 5:
                        res.send(threads);
                        return [2 /*return*/];
                }
            });
        });
    }
    var postId, arr, threadHash, threadIds, postIds, publisherAddresses, donations, upvotes, i;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                postId = req.params.pid;
                return [4 /*yield*/, getAllThreads(postId)];
            case 1:
                arr = _a.sent();
                threadHash = [];
                threadIds = [];
                postIds = [];
                publisherAddresses = [];
                donations = [];
                upvotes = [];
                for (i = 0; i < arr.length; i++) {
                    threadIds.push(arr[i][0]);
                    postIds.push(arr[i][1]);
                    publisherAddresses.push(arr[i][2]);
                    donations.push(arr[i][3]);
                    upvotes.push(arr[i][4]);
                    threadHash.push(arr[i][5]);
                }
                getAllThreadsData(threadHash, threadIds, postIds, publisherAddresses, donations, upvotes);
                return [2 /*return*/];
        }
    });
}); });
app.post('/donatetofact/:pid/:uid', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var postId, userAddr, Amount, reqbody, resp;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                postId = parseInt(req.params.pid);
                return [4 /*yield*/, getUserInfo(req.params.uid)];
            case 1:
                userAddr = _a.sent();
                Amount = parseInt(req.body.amount);
                reqbody = {
                    amount: Amount,
                    from: userAddr,
                    factId: postId
                };
                return [4 /*yield*/, donateFact(reqbody)];
            case 2:
                resp = _a.sent();
                if (!resp) {
                    res.send({ success: false, error: 'Something went wront' });
                }
                else {
                    res.send({ success: true, txHash: resp });
                }
                return [2 /*return*/];
        }
    });
}); });
app.post('/donatetothread/:pid/:tid/:uid', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var postId, ThreadId, userAddr, Amount, reqbody, resp;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                postId = req.params.pid;
                ThreadId = req.params.tid;
                return [4 /*yield*/, getUserInfo(req.params.uid)];
            case 1:
                userAddr = _a.sent();
                Amount = req.body.amount;
                reqbody = {
                    amount: Amount,
                    from: userAddr,
                    factId: postId,
                    threadId: ThreadId
                };
                return [4 /*yield*/, donateThread(reqbody)];
            case 2:
                resp = _a.sent();
                if (!resp) {
                    res.send({ success: false, error: 'Something went wront' });
                }
                else {
                    res.send({ success: true, txHash: resp });
                }
                return [2 /*return*/];
        }
    });
}); });
app.get('/getaccountdetails/:uid', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var userAddr, balance;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0: return [4 /*yield*/, getUserInfo(req.params.uid)];
            case 1:
                userAddr = _a.sent();
                return [4 /*yield*/, getBalance(userAddr)];
            case 2:
                balance = _a.sent();
                res.send({ userAddress: userAddr, balance: balance });
                return [2 /*return*/];
        }
    });
}); });
app.post('/buytokens/:uid', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var userAddr, amount, resp;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0: return [4 /*yield*/, getUserInfo(req.params.uid)];
            case 1:
                userAddr = _a.sent();
                amount = req.body.amount;
                return [4 /*yield*/, addBalance(userAddr, amount)];
            case 2:
                resp = _a.sent();
                if (!resp) {
                    res.send({ success: false, error: 'Something went wrong' });
                }
                else {
                    res.send({ success: true, txHash: resp });
                }
                return [2 /*return*/];
        }
    });
}); });
//Routes End
app.listen(process.env.PORT || 5000, function () { console.log("server running port 3000"); });
