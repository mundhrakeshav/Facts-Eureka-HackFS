pragma solidity ^0.5.0;


contract FactCheck {
    uint256 public postCount;                //Count of total posts

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

    function createPost(string memory _ipfsHash, bytes32 _hash, bytes memory signatureObject) public {
        //checkout recover method for exact signing method
        //ipfs hash need to be signed message
        //_hash is someHow processed ipfsHash check recover function
        address signer = recover(_hash, signatureObject);   //recovering the signer
        facts[postCount++] = Fact(signer, _ipfsHash, 0, 0, 0);
        //Fact(publisher, ipfsHash, threadCount, donation, upvotes, downvotes) and 2 mappings
    }

    function createThread(uint256 postID, string memory _ipfsHash, bytes32 _hash, bytes memory signatureObject) public {
        //checkout recover method for exact signing method
        //_ipfsHash need to be signed message

        require(postID <= postCount);
        address signer = recover(_hash, signatureObject);   //recovering the signer
        facts[postID].threads[facts[postID].threadCount++] = Thread(signer, _ipfsHash, 0, 0);    //adding thread to a post
    }

    function upVoteFact(uint256 postID, bytes memory signatureObject, bytes32 _hash) public {
        //_hash is has of PostID and UserAddress
        //signatureObject is signed _hash

        require(postID <= postCount, "invalid post id");
        address signer = recover(_hash, signatureObject);   //recovering the signer
        require(!facts[postID].hasUserUpvoted[signer], "User has already upvoted");
        facts[postID].upvotes++;
        facts[postID].hasUserUpvoted[signer] = true;

    }

    function upVoteThread(uint256 postID, uint256 threadID, bytes memory signatureObject, bytes32 _hash) public {
        //_hash is has of postID, threadID and UserAddress
        //signatureObject is signed _hash

        require(postID <= postCount, "invalid post id");
        require(threadID <= facts[postID].threadCount, "invalid Thread id");
        address signer = recover(_hash, signatureObject);   //recovering the signer
        require(!facts[postID].threads[threadID].hasUserUpvoted[signer], "User has already upvoted");
        facts[postID].threads[threadID].upvotes++;
        facts[postID].threads[threadID].hasUserUpvoted[signer] = true;
    }

    function donateToFact(uint256 amount, address from, address to) public {
        //TODO danate ERC20 token
    }

    function donateToThread(uint256 amount, address from, address to) public {

    }

    function recover(bytes32 hash, bytes memory signature)
    public
    pure
    returns (address) {
      //  @dev Recover signer address from a message by using their signature
      //  @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
      //  @param signature bytes signature, the signature is generated using ethers

      //   const sign_confirmation = async (data, private_key) => {
      //   console.log(data); //this is how data can be signed, hash needs to be same
      //   let pre_hash = ethers.utils.solidityKeccak256(["string"], [data]);
      //   let msg_hash = accounts.hashMessage(pre_hash);
      //   let signingKey = new ethers.utils.SigningKey(private_key);
      //   let signed_msg = signingKey.signDigest(msg_hash);
      //   signed_msg = ethers.utils.joinSignature(signed_msg);
      //   console.log(" message hash   \n", msg_hash);
      //   console.log("Signed message hash   \n", signed_msg);
      // };
      // sign_confirmation( data ,  private_key );
      // recover(msg_hash, signature);

        require(signature.length == 65, "Signature length is unequal to 65");

        bytes32 r;
        bytes32 s;
        uint8 v;

        // Check the signature length

        // Divide the signature in r, s and v variables
        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }

        // If the version is correct return the signer address
        require(v == 27 || v == 28, "Incorrect v");

        return ecrecover(hash, v, r, s);

    }
}
