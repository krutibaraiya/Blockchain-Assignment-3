/*
    Assignment 3 : Dexter's Royal Entry
    
    Team members:
        1) Baraiya Kruti - 2019A7PS1260H
        2) Vedansh Srivastava - 2019A7PS0323H
        3) Umang Agarwal - 2019A7PS0185H
*/

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

/*
    ASSUMPTIONS:
        - Gas limit : 3000000
        - Price of 1 Royal Entry Token (RET) = 10 wei
        
        - The user already has 1 RET with him initially
        - The user has an initial account balance of 10 wei (sufficient to buy only 1 RET; increase balance of wallet using addToWallet)
    
*/

contract Dexter_smart_contract {
    
    address public owner;           //address of owner account
    uint public initialTokens = 1;      //initial number of RETs with the owner
    uint public initialBalance = 10;    //initial account balance of the owner 
    uint rate = 10;   //we have assumed price of 1 RET to be 10 units
    
    mapping(address => uint) wallet;        //mapping for user wallet balance
    mapping(address => uint) RET;           //mapping for RET balance
    
    event RET_Bought(address buyer, uint amount);           //event indicating buying of tokens
    event RET_Used(address user, uint amount);              //event indicating usage of tokens
    event RET_Sold(address seller, uint amount);            //event indicating sale of tokens
    
    constructor() {
        owner = msg.sender;
        RET[owner] = initialTokens;
        wallet[owner] = initialBalance;
    }
    
    
    /* 
        Function to add balance to wallet:
            - requires the user to enter the address and the amount to be added in the wallet
            - And the wallet balance gets incremented
    */
    function addToWallet(address _to, uint amount) external {
        wallet[_to] += amount;
    }
    
    
    /*
        Function to check balance of wallet:
            - requires the user to enter the address of the account 
            - returns wallet balance of the account
    */
    function balanceOfWallet(address account) external view returns (uint) {
        return wallet[account];
    }
    
    
    /*
        Function to check balance of RETs in account:
            - requires to enter the address of the account whose token balance needs to be checked
            - returns token balance associated with the account
    */
    function balanceOfTokens(address account) external view returns (uint) {
        return RET[account];
    }
    
    
    /* 
        Function to buy RETs : 
            - requires user to enter address of buyer and the amount of tokens he wishes to purchase
            - buyer's wallet should have sufficient balance in wallet (ie rate of 1 RET * amount of tokens he wishes to buy)
            - Accordingly, wallet balance buyer gets decremented
            - Token balance of buyer gets incremented
            - Event is emitted indicating that token(s) is/are sucessfully bought
    */
    function buyTokens(address buyer, uint amount) external {

        require(wallet[buyer] >= 10*amount, "Insufficient balance in wallet!");
        require(msg.sender == buyer, "Unauthorised Access!");

        wallet[buyer] -= rate*amount;
        RET[buyer] += amount;
        
        emit RET_Bought(buyer, amount);
    }
    
    
    /* 
        Function to use RETs:
            - requires to enter the address of user and the amount of tokens to be spent
            - user should have sufficient token balance
            - RET balance of user gets decremented 
            - Finally, event indicating usage of tokens gets emitted
    */
    function useTokens(address user, uint amount) external {

        require(RET[user] >= amount, "Insufficient balance of tokens!");
        require(msg.sender == user, "Unauthorised Access!");

        RET[user] -= amount;
        emit RET_Used(user, amount);
    }
    
    
    /*
        Function to sell RETs:
            - requires to enter the address of seller account and the amount of tokens to be sold
            - the seller should have sufficient token balance to sell
            - Accordingly, RET balance of the seller gets decremented and wallet balance gets incremented from the sale
            - Event indicating sale of tokens is emitted
    */
    function sellTokens(address seller, uint amount) external {

        require(RET[seller] >= amount, "Insufficient balance of tokens!");
        require(msg.sender==seller, "Unauthorised Access!");

        RET[seller] -= amount;
        wallet[seller] += rate*amount;
        emit RET_Sold(seller, amount);
    }
    
    
}
