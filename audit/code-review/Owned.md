# Owned

Source file [../../contracts/Owned.sol](../../contracts/Owned.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Owned - Ownership model with 2 phase transfers
// Enuma Blockchain Framework
//
// Copyright (c) 2017 Enuma Technologies.
// http://www.enuma.io/
// ----------------------------------------------------------------------------


// Implements a simple ownership model with 2-phase transfer.
// BK Ok
contract Owned {

   // BK Next 2 Ok
   address public owner;
   address public proposedOwner;

   // BK Next 2 Ok - Events
   event OwnershipTransferInitiated(address indexed _proposedOwner);
   event OwnershipTransferCompleted(address indexed _newOwner);


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


   // BK Ok - Only proposed owner can execute
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
