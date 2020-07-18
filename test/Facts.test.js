const assert=require('assert');
const ganache=require('ganache-cli');

const Web3=require('web3');//capital Web3 bcz later will create instrace web3
const provider=ganache.provider()
const web3=new Web3(provider);
const {interface,bytecode}=require('../compile');

let accounts;
let facts;


beforeEach(async ()=>{
accounts=await web3.eth.getAccounts();
facts=await new web3.eth.Contract(JSON.parse(interface)).deploy({data:bytecode,arguments:['Facts','FKT','4']})
  .send({from:accounts[0],gas:'3000000'});
  facts.setProvider(provider);
});

describe('Facts Testing',()=>{
  it('deploys the contract',()=>{
    //presenece of address tells that contract is deployed successfully in deployed contract facts.
    //console.log(facts);
    assert.ok(facts.options.address);
  });

  it('Name symbol decimals set',async ()=>{
    const name=await facts.methods.name().call();
    const sym=await facts.methods.symbol().call();
    const deci=await facts.methods.decimals().call();
    assert.equal(name,'Facts');
    assert.equal(deci,'4');
    assert.equal(sym,'FKT');
  });

  it('Mint and check balance',async()=>{
          await facts.methods.mint(accounts[1],'200').send({from:accounts[1]});
          const balance=await facts.methods.balanceOf(accounts[1]).call();
          assert.equal(balance,'200');
  })

  it('Create a post and donate to post',async ()=>{
      await facts.methods.mint(accounts[1],'200').send({from:accounts[1]});
      await facts.methods.createPost('hash',accounts[0]).send({from:accounts[0]});
      const postCount=await facts.methods.postCount().call();
      assert.equal(postCount,'1');
      await facts.methods.donateToFact('5',accounts[1],'0').send({from:accounts[1]});
      const balance=await facts.methods.balanceOf(accounts[1]).call();
      assert.equal(balance,'195');
      const data1=await facts.methods.facts('0').call();
      //console.log(data1);
  })

  it('UpVoting a post',async ()=>{
    await facts.methods.createPost('hash',accounts[0]).send({from:accounts[0]});
    await facts.methods.upVoteFact('0',accounts[1]).send({from:accounts[1]});
    const data= await facts.methods.facts('0').call();
    assert.equal(data.upvotes,'1');
  })

  it('Create a thread and donate to thread',async ()=>{
      await facts.methods.mint(accounts[1],'200').send({from:accounts[1]});
      await facts.methods.createPost('hash',accounts[0]).send({from:accounts[0]});
      await facts.methods.createThread('0','hash1',accounts[3]).send({from:accounts[3]});
      await facts.methods.donateToThread('15',accounts[1],'0','0').send({from:accounts[1]});
      const balance=await facts.methods.balanceOf(accounts[1]).call();
      assert.equal(balance,'185');
      const data1=await facts.methods.facts('0').call();
       //console.log(data1);
  })


});
