# Finalizable

Source file [../../contracts/Finalizable.sol](../../contracts/Finalizable.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Finalizable - Basic implementation of the finalization pattern
// Enuma Blockchain Framework
//
// Copyright (c) 2017 Enuma Technologies.
// http://www.enuma.io/
// ----------------------------------------------------------------------------


// BK Ok
import "./Owned.sol";


// BK Ok
contract Finalizable is Owned {

   // BK Ok
   bool public finalized;

   // BK Ok - Event
   event Finalized();


   // BK Ok - Constructor
   function Finalizable() public
      Owned()
   {
      // BK Ok
      finalized = false;
   }


   // BK Ok - Only owner can execute
   function finalize() public onlyOwner returns (bool) {
      // BK Ok
      require(!finalized);

      // BK Ok
      finalized = true;

      // BK Ok - Log event
      Finalized();

      // BK Ok
      return true;
   }
}

```
