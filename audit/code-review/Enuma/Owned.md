# Owned

Source file [../../../contracts/Enuma/Owned.sol](../../../contracts/Enuma/Owned.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------
// Owned - Ownership model with 2 phase transfers
// Enuma Blockchain Platform
//
// Copyright (c) 2017 Enuma Technologies.
// https://www.enuma.io/
// ----------------------------------------------------------------------------


// Implements a simple ownership model with 2-phase transfer.
// BK Ok
contract Owned {

   // BK Next 2 Ok
   address public owner;
   address public proposedOwner;

   // BK Next 3 Ok - Events
   event OwnershipTransferInitiated(address indexed _proposedOwner);
   event OwnershipTransferCompleted(address indexed _newOwner);
   event OwnershipTransferCanceled();


   // BK Ok - Constructor
   function Owned() public
   {
      // BK Ok
      owner = msg.sender;
   }


   // BK Ok
   modifier onlyOwner() {
      // BK Ok
      require(isOwner(msg.sender) == true);
      // BK Ok
      _;
   }


   // BK Ok - Constant function
   function isOwner(address _address) public view returns (bool) {
      // BK Ok
      return (_address == owner);
   }


   // BK Ok - Only owner can execute
   function initiateOwnershipTransfer(address _proposedOwner) public onlyOwner returns (bool) {
      // BK Next 3 Ok
      require(_proposedOwner != address(0));
      require(_proposedOwner != address(this));
      require(_proposedOwner != owner);

      // BK Ok
      proposedOwner = _proposedOwner;

      // BK Ok - Log event
      OwnershipTransferInitiated(proposedOwner);

      // BK Ok
      return true;
   }


   // BK Ok - Only owner can execute
   function cancelOwnershipTransfer() public onlyOwner returns (bool) {
      // BK OK
      if (proposedOwner == address(0)) {
         // BK Ok
         return true;
      }

      // BK Ok
      proposedOwner = address(0);

      // BK Ok
      OwnershipTransferCanceled();

      // BK Ok
      return true;
   }


   function completeOwnershipTransfer() public returns (bool) {
      // BK Ok
      require(msg.sender == proposedOwner);

      // BK Next 2 Ok
      owner = msg.sender;
      proposedOwner = address(0);

      // BK Ok - Log event
      OwnershipTransferCompleted(owner);

      // BK Ok
      return true;
   }
}

```
