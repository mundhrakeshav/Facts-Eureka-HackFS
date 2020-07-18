const HDWalletProvider=require('truffle-hdwallet-provider');
const Web3=require('web3');
const {interface,bytecode}=require('./compile');
const config=require('./config');
const provider=new HDWalletProvider(
  config.keys.metamask,
  config.keys.infura
);

const web3=new Web3(provider);


const deploy=async()=>{
  const accounts=await web3.eth.getAccounts();


  console.log('Attempting to deploy account',accounts[0]);
  const result=await new web3.eth.Contract(JSON.parse(interface)).deploy({data:bytecode,arguments:['Facts','FKT','4']})
  .send({gas:'3000000',from:accounts[0]});
  console.log('Contract depeloped to',result.options.address);
};

deploy();
