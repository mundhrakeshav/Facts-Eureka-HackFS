pragma solidity ^0.5.0;

import "./ERC20Mintable.sol"

contract FactCheck {
    uint256 public postCount;
     address public assetContract;                       //Count of total posts
     mapping(address=>uint) buyersTokens;      //buyers mapped to no of tokens they are owning.
     event TokensPurchased(address buyer,amount uint);
     event DonateFact(address from,address to,uint amount);
     event DonateThread(address from address to,uint amount);
    struct Fact {
        address publisher;                          //address of publisher
        string  ipfsHash;                           //ipfsHash of fact
        mapping (uint256 => Thread) threads;        //mapping containing each thread
        uint256 threadCount;                        //Total number of threads/subPost
        uint256 donations;                          //total amount donated to this particular post
        mapping (address => bool) hasUserUpvoted;   //mapping to see if a particular user has upvoted the post
        uint256 upvotes;                            //total number of upvotes on a post
    }

    struct Thread {
        address publisher;                          //address of publisher
        string  ipfsHash;                           //ipfsHash of thread
        uint256 donations;                          //total donations to this thread
        mapping (address => bool) hasUserUpvoted;   //mapping to see if a particular user has upvoted the post
        uint256 upvotes;                            //total number of upvotes
    }

    mapping (uint256 => Fact) public facts;    //map of uint to each fact

    constructor(address _assetContract) public {
        require(_assetContract != address(0),"Not a valid address");
        assetContract=_assetContract;                      //postCount initialized to 0
    }

    function createPost(string memory _ipfsHash, address publisher) public {
        facts[postCount++] = Fact(publisher, _ipfsHash, 0, 0, 0);
        //Fact(publisher, ipfsHash, threadCount, donation, upvotes, downvotes) and 2 mappings
    }

    function createThread(uint256 postID, string memory _ipfsHash, address publisher) public {
        require(postID <= postCount);
        facts[postID].threads[facts[postID].threadCount++] = Thread(publisher, _ipfsHash, 0, 0);    //adding thread to a post 
    }


    function upVoteFact(uint256 postID, address user) public {
        
        require(postID <= postCount,"invalid post id");   //recovering the signer
        require(!facts[postID].hasUserUpvoted[user], "User has already upvoted");
        facts[postID].upvotes++;
        facts[postID].hasUserUpvoted[user]=true;
        
    }
    
    
    function upVoteThread(uint256 postID, uint256 threadID, address user) public {
  
        require(postID <= postCount,"invalid post id");
        require(threadID <= facts[postID].threadCount,"invalid Thread id");
        require(!facts[postID].threads[threadID].hasUserUpvoted[user],"User has already upvoted");
        facts[postID].threads[threadID].upvotes++;
        facts[postID].threads[threadID].hasUserUpvoted[user] = true;
    }
    
    
    function donateToFact(uint256 amount, address from, uint256 factId) public {
        require(factId>0&&factId<=postCount&&buyers[from]>=amount,"Invalid Post Id");
        Fact memory fact=facts[factId];
        address _Factpublisher=fact.publisher;
        buyers[from]-=amount;
        ERC20Mintable erc_obj = ERC20Mintable(assetContract);
        uint allowance= erc_obj.allowance(from,address(this));
        require(allowance>=amount);
        erc_obj.transfer(_Factpublisher,amount);
        emit(from,_Factpublisher,amount);
    
    }
    
    function donateToThread(uint256 amount, address from, uint256 factId, uint256 threadId) public {
         require(factId>0&&factId<=postCount&&buyers[from]>=amount&&facts[factId].threadCount>=threadId&&threadId>=0,"Invalid Post Id");
        address _Threadpublisher = facts[factId].threads[threadId].publisher;
        buyers[from]-=amount;
        ERC20Mintable erc_obj = ERC20Mintable(assetContract);
        uint allowance= erc_obj.allowance(from,address(this));
        require(allowance>=amount);
        erc_obj.transfer(_Threadpublisher,amount);
        emit(from,_Threadpublisher,amount);
    }

    function BuyFactsToken(uint amount,address buyer) public{
          ERC20Mintable erc_obj = ERC20Mintable(assetContract);
          bool s = erc_obj.mint(buyer,amount);   //minting increases totalsupply of tokens and sets balance of buyer.
          require(s,"Couldn't Buy the tokens");
          buyersTokens[buyer]=amount;
          erc_obj.approve(address(this),amount);//make this contact as spender sets allowance.
          erc.obj.transferFrom(buyer,address(this),amount); //    transfers tokens and reduces allowance
          emit(buyer,amount);

    }