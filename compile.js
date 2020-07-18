const path=require('path');
const fs=require('fs');
const solc=require('solc');

const factspath=path.resolve(__dirname,'contracts','Facts.sol');
const source=fs.readFileSync(factspath,'utf8');
//console.log(solc.compile(source,1).contracts[':FactCheck']);
//abi-interface
module.exports=solc.compile(source,1).contracts[':FactCheck'];
