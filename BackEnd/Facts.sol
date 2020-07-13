pragma solidity ^0.5.0;


contract FactCheck {
    uint256 public postCount;                       //Count of total posts

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

    constructor() public {
        postCount = 0;                         //postCount initialized to 0
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
        
        address reciever = facts[factId].publisher;
        //Todo transfer erc20 to reciever  
    
    }
    
    function donateToThread(uint256 amount, address from, uint256 factId, uint256 threadId) public {
     
             address reciever = facts[factId].threads[threadId].publisher;
        //Todo transfer erc20 to reciever  

        
    }

