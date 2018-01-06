# FinalizableToken

Source file [../../contracts/FinalizableToken.sol](../../contracts/FinalizableToken.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// FinalizableToken - Extension to ERC20Token with ops and finalization
// Enuma Blockchain Framework
//
// Copyright (c) 2017 Enuma Technologies.
// http://www.enuma.io/
// ----------------------------------------------------------------------------

// BK Next 4 Ok
import "./ERC20Token.sol";
import "./OpsManaged.sol";
import "./Finalizable.sol";
import "./Math.sol";


//
// ERC20 token with the following additions:
//    1. Owner/Ops Ownership
//    2. Finalization
//
// BK Ok
contract FinalizableToken is ERC20Token, OpsManaged, Finalizable {

   // BK Ok
   using Math for uint256;


   // The constructor will assign the initial token supply to the owner (msg.sender).
   // BK Ok - Constructor
   function FinalizableToken(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public
      ERC20Token(_name, _symbol, _decimals, _totalSupply, msg.sender)
      OpsManaged()
      Finalizable()
   {
   }


   // BK Ok
   function transfer(address _to, uint256 _value) public returns (bool success) {
      // BK Ok
      validateTransfer(msg.sender, _to);

      // BK Ok
      return super.transfer(_to, _value);
   }


   // BK Ok
   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
      // BK Ok
      validateTransfer(msg.sender, _to);

      // BK Ok
      return super.transferFrom(_from, _to, _value);
   }


   // BK Ok
   function validateTransfer(address _sender, address _to) private view {
      // Once the token is finalized, everybody can transfer tokens.
      // BK Ok
      if (finalized) {
         // BK Ok
         return;
      }

      // BK Ok
      if (isOwner(_to)) {
         // BK Ok
         return;
      }

      // Before the token is finalized, only owner and ops are allowed to initiate transfers.
      // This allows them to move tokens while the sale is still ongoing for example.
      // BK Ok
      require(isOwnerOrOps(_sender));
   }
}



```
