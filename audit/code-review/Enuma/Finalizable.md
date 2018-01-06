# Finalizable

Source file [../../../contracts/Enuma/Finalizable.sol](../../../contracts/Enuma/Finalizable.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------
// Finalizable - Basic implementation of the finalization pattern
// Enuma Blockchain Platform
//
// Copyright (c) 2017 Enuma Technologies.
// https://www.enuma.io/
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
