// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract SubCurrency {
    // The keyword "public" makes variables
    // accessible from other contracts

    error SubCurrency_NotOwner();
    address public minter;
    mapping (address => uint) public balances;

    // Events allow clients to react to specific
    // contract changes you declare
     /* Event is an inheritable member of a contract. An event is emitted, it stores the arguments passed in transaction logs. 
     These logs are stored on blockchain and are accessible using address of the contract till the contract is present on the blockchain. */ 
    event Sent(address from, address to, uint amount);

    // Constructor code is only run when the contract
    // is created
    constructor() {
        minter = msg.sender;
    }
     

      
    modifier onlyOwner {
        // require(msg.sender == owner);
        if (msg.sender != minter) revert SubCurrency_NotOwner();
        _;
    }
    // Sends an amount of newly created coins to an address
    // Can only be called by the contract creator
    function mint(address receiver, uint amount) onlyOwner() public  {
        balances[receiver] += amount;
    }

     function mint2(address receiver, uint amount) public  {
        balances[receiver] += amount;
    }

    // Errors allow you to provide information about
    // why an operation failed. They are returned
    // to the caller of the function.
    error InsufficientBalance(uint requested, uint available);

    // Sends an amount of existing coins
    // from any caller to an address
    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });
         assert(balances[msg.sender] - amount >= 0);
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }


    function getOwner() external view returns(address){
        return minter;
    }

    function getBalanceOf(address user) external view returns(uint){
        return balances[user];
    }


}