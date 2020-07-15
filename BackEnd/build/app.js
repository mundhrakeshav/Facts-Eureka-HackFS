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
var web3provider = 'https://goerli.infura.io/v3/ee0e744e0cfe471ab09c8ef8efa2b08f';
var web3 = new Web3(new Web3.providers.HttpProvider(web3provider));
var threadId = hub_1.ThreadID.fromString('bafkwf6lewg4eaodvqms5feq35lqik4bydfswx3722qz2ltqzy3qopka');
app.use(bodyParser.json());
var firebaseConfig = {
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
var ercInstance = axios.create({
    baseURL: 'https://beta-api.ethvigil.com/v0.1/contract/0x5a91e18c458e21afd7fc2051168484598c59d3e7',
    timeout: 5000,
    headers: { 'X-API-KEY': 'c6cde06b-d6d3-4c10-9007-e6f6074c6983' }
});
function createUser(uid) {
    return __awaiter(this, void 0, void 0, function () {
        var identityKey, ethAccount;
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
                    return [2 /*return*/, ethAccount.address];
            }
        });
    });
}
function signup_mint(wallet_addr) {
    return __awaiter(this, void 0, void 0, function () {
        return __generator(this, function (_a) {
            ercInstance.post('/mint', {
                account: wallet_addr,
                amount: 1000
            })
                .then(function (response) {
                console.log(response.data);
                return response.data;
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
            });
            return [2 /*return*/];
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
function getUserInfo(uid) {
    return __awaiter(this, void 0, void 0, function () {
        return __generator(this, function (_a) {
            firebase.database().ref('/users').child(uid).once('value').then(function (snapshot) {
                var details = snapshot.val();
                return details;
            });
            return [2 /*return*/];
        });
    });
}
app.get('/generatekeys/:id', function (req, res) {
    var UserId = req.params.id;
    var ethAddress = createUser(UserId);
    var mintTxHash = signup_mint(ethAddress);
    res.send({ success: true, ethAddress: ethAddress, signUpHash: mintTxHash });
});
app.post('/addpost/:id', function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var post, uid, postID, userInfo;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                post = req.body;
                uid = req.params.id;
                return [4 /*yield*/, createPost(post)]; //Signing and passing to smart contract pending
            case 1:
                postID = _a.sent() //Signing and passing to smart contract pending
                ;
                userInfo = getUserInfo(uid);
                res.send({ postID: postID });
                return [2 /*return*/];
        }
    });
}); });
app.listen(3000, function () { console.log("server running port 3000"); });
