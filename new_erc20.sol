pragma solidity ^0.4.24; //Declaring the solidity version

import "contracts/Owner.sol";
import "hardhat/console.sol";

//Safe Math Interface
 
contract SafeMath { // Calling the Safe Math interface to use math functions in our contract.
 
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
 
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
 
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
 
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
 
 
//ERC Token Standard #20 Interface
 
contract ERC20Interface { //Calling the ERC-20 Interface to implement its functions.
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
 
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
 
 
//Contract function to receive approval and execute function in one call
 
contract ApproveAndCallFallBack { // A Contract function to receive approval and execute a function in one call.
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}
 
//Actual token contract
 
contract TCtoken is ERC20Interface, SafeMath, Owner { 

/* Starting my TCtoken contract, creating a variable symbol of string type to
hold my token’s symbol, a variable name of string type to hold my token’s name, 
variable decimals of unsigned integer type to hold the decimal value for the token division. */

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    bool public Block_var;
 
 // Creating two mapping functions that will grant users the ability to spend these tokens.
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
 
 // Initializing the constructor, setting symbol, name, decimals, and total supply value for my token. 
 // Declaring the total supply of the token to be equal to my wallet’s balance for this token.

    constructor() public {
        symbol = "TC";
        name = "Test Coin";
        decimals = 2;
        Block_var = false;
        _totalSupply = 100000;
        balances[0x72b433a537D24dEC55a999435746E7b2f22848bA] = _totalSupply;
        emit Transfer(address(0), 0x72b433a537D24dEC55a999435746E7b2f22848bA, _totalSupply);
    }
 
    modifier Blocking {
        require(
            Block_var == false,
            "All functions are blocked"    );
        _;
    }


 // Function totalSupply which will govern the total supply of our token.
    function totalSupply() public Blocking constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

 //Function balanceOf which will check the balance of a wallet address.
    function balanceOf(address tokenOwner) public Blocking constant returns (uint balance) {
        return balances[tokenOwner];
    }
 
 //Function transfer which will execute the transfer of tokens from the total supply to users.
    function transfer(address to, uint tokens) public Blocking returns (bool success) {
            balances[msg.sender] = safeSub(balances[msg.sender], tokens);
            balances[to] = safeAdd(balances[to], tokens);
            emit Transfer(msg.sender, to, tokens);
            return true;
        }
 
 //Function approve which will check if the total supply has the amount of token which needs to be allocated to a user.
    function approve(address spender, uint tokens) public Blocking returns (bool success) {
            allowed[msg.sender][spender] = tokens;
            emit Approval(msg.sender, spender, tokens);
            return true;
        }
 
 //Function transferFrom which will facilitate the transfer of token between users.
    function transferFrom(address from, address to, uint tokens) public Blocking returns (bool success) {
            balances[from] = safeSub(balances[from], tokens);
            allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
            balances[to] = safeAdd(balances[to], tokens);
            emit Transfer(from, to, tokens);
            return true;
        }
 
 //Function allowance which will check if a user has enough balance to perform the transfer to another user.
    function allowance(address tokenOwner, address spender) public Blocking constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
 
 //Function approveAndCall which executes the transactions of buying and spending of tokens.
    function approveAndCall(address spender, uint tokens, bytes data) public Blocking returns (bool success) {
            allowed[msg.sender][spender] = tokens;
            emit Approval(msg.sender, spender, tokens);
            ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
            return true;
        }

// Block function to block all other functions
    function Block() public isOwner returns (bool success) {
            Block_var = true;
            return Block_var;
        }
        

    // Block function to block all other functions
    function UnBlock() public isOwner returns (bool success) {
            Block_var = false;
            return Block_var;
        }

 
 // Fallback function to prevent accounts from directly sending ETH to the contract, this prevents the 
 // users from spending gas on transactions in which they forget to mention the function name.
    function () public Blocking payable {
        revert();
    }
}