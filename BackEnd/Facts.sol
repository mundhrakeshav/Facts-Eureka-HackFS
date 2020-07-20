pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);


    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

}

contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string internal _name;
    string internal _symbol;
    uint8 internal _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount <= _balances[from]);

        _balances[from] = _balances[from].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[to] = _balances[to].add(amount);
        emit Transfer(from, to, amount);
        return true;
    }


    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

}



contract FactCheck is ERC20 {
    uint256 public postCount;                       //Count of total posts

    address public assetContract;                   // Attached ERC20





    struct Fact {
        address publisher;                          //address of publisher
        string  ipfsHash;                           //ipfsHash of fact
        mapping (uint256 => Thread) threads;        //mapping containing each thread
        uint256 threadCount;                        //Total number of threads/subPost
        uint256 donations;                          //total amount donated to this particular post
        mapping (address => bool) hasUserUpvoted;   //mapping to see if a particular user has upvoted the post
        uint256 upvotes;                            //total number of upvotes on a post
        mapping(address => bool) hasUserPurchased;  //mapping to see if a particular user has paid for the fact
    }

    //struct Fact[] posts;

    struct Thread {
        address publisher;                          //address of publisher
        string  ipfsHash;                           //ipfsHash of thread
        uint256 donations;                          //total donations to this thread
        mapping (address => bool) hasUserUpvoted;   //mapping to see if a particular user has upvoted the post
        uint256 upvotes;                            //total number of upvotes
    }

    mapping (uint256 => Fact) public facts;    //map of uint to each fact

    constructor (string memory name, string memory symbol, uint8 decimals) public ERC20(name, symbol, decimals){
        postCount = 0;                        //postCount initialized to 0
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }


    function createPost(string memory _ipfsHash, address publisher) public {
       Fact memory post= Fact({publisher:publisher,ipfsHash:_ipfsHash,threadCount:0,donations:0,upvotes:0});
        //Fact(publisher, ipfsHash, threadCount, donation, upvotes, downvotes) and 2 mappings
        facts[postCount++]=post;
    }

    function createThread(uint256 postID, string memory _ipfsHash, address publisher) public {
        require(postID <= postCount);
        facts[postID].threads[facts[postID].threadCount++] = Thread({publisher:publisher,ipfsHash:_ipfsHash,donations:0,upvotes:0});    //adding thread to a post
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
            transferFrom(from, reciever, amount);
             facts[factId].donations+=amount;
    }

    function donateToThread(uint256 amount, address from, uint256 factId, uint256 threadId) public {

         address reciever = facts[factId].threads[threadId].publisher;
        //Todo transfer erc20 to reciever
            transferFrom(from, reciever, amount);
            facts[factId].threads[threadId].donations+=amount;

    }


       function mint(address account, uint256 amount) public returns (bool) {
        _mint(account, amount);
        return true;
    }

    //  function getAllPosts() public view returns (address[] memory,string[] hash,uint[] memory,uint[] memory) {
    //      address[] memory _publisher = new address[](postCount);
    //      uint[]  memory _donations = new uint[](postCount);
    //      uint[] memory _upvotes = new uint[](postCount);
    //      string[] memory _hash=new string[](postCountt);
    //   for (uint i = 0; i < postCount; i++) {
    //       Fact storage f = facts[i];
    //       _publisher[i] = f.publisher;
    //       _donations[i] = f.donations;
    //       _upvotes[i] = f.upvotes;
    //       _hash[i]=f.ipfsHash;
    //   }

    //   return (_publisher,_hash,_donations,_upvotes);
    // }



      struct Posts{
          uint postID;
          address publisher;
          uint donations;
          uint upvotes;
          string ihash;
          Thread1[] t;
      }
      struct Thread1{
          uint threadID;
          uint postID;
          address publisher;
          uint donations;
          uint upvotes;
          string ihash;
      }

      function getAllPosts() public view  returns(Posts[] memory){
          Posts[] memory p=new Posts[](postCount);
          for(uint i=0;i<postCount;i++){
              p[i].postID = i;
              p[i].publisher=facts[i].publisher;
              p[i].donations=facts[i].donations;
              p[i].upvotes=facts[i].upvotes;
              p[i].ihash=facts[i].ipfsHash;
              p[i].t=new Thread1[](facts[i].threadCount);
              for(uint j=0;j<facts[i].threadCount;j++){
                  p[i].t[j].postID = i;
                  p[i].t[j].threadID=j;
                  p[i].t[j].publisher=facts[i].threads[j].publisher;
                  p[i].t[j].donations=facts[i].threads[j].donations;
                  p[i].t[j].upvotes=facts[i].threads[j].upvotes;
                 p[i].t[j].ihash=facts[i].threads[j].ipfsHash;
              }
          }

          return p;
      }
}