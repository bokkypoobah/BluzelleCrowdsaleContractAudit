# BluzelleToken

Source file [../../contracts/BluzelleToken.sol](../../contracts/BluzelleToken.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------
// BluzelleToken - ERC20 Compatible Token
//
// Copyright (c) 2017 Bluzelle Networks Pte Ltd.
// http://www.bluzelle.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

// BK Next 2 Ok
import "./Enuma/FinalizableToken.sol";
import "./BluzelleTokenConfig.sol";


// ----------------------------------------------------------------------------
// The Bluzelle token is a standard ERC20 token with the addition of a few
// concepts such as:
//
// 1. Finalization
// Tokens can only be transfered by contributors after the contract has
// been finalized.
//
// 2. Ops Managed Model
// In addition to owner, there is a ops role which is used during the sale,
// by the sale contract, in order to transfer tokens.
// ----------------------------------------------------------------------------
// BK Ok
contract BluzelleToken is FinalizableToken, BluzelleTokenConfig {


   // BK Ok - Event
   event TokensReclaimed(uint256 _amount);


   // BK Ok - Constructor
   function BluzelleToken() public
      FinalizableToken(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, TOKEN_TOTALSUPPLY)
   {
   }


   // Allows the owner to reclaim tokens that have been sent to the token address itself.
   // BK Ok - Only owner can execute
   function reclaimTokens() public onlyOwner returns (bool) {

      // BK Ok
      address account = address(this);
      // BK Ok
      uint256 amount  = balanceOf(account);

      // BK Ok
      if (amount == 0) {
         // BK Ok
         return true;
      }

      // BK Ok
      balances[account] = balances[account].sub(amount);
      // BK Ok
      balances[owner] = balances[owner].add(amount);

      // BK NOTE - The `Transfer(...)` event should be emitted here as blockchain explorers will pick it up
      // BK Ok
      TokensReclaimed(amount);

      // BK Ok
      return true;
   }
}


```
