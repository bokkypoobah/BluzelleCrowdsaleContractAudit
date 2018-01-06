# OpsManaged

Source file [../../../contracts/Enuma/OpsManaged.sol](../../../contracts/Enuma/OpsManaged.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------
// OpsManaged - Implements an Owner and Ops Permission Model
// Enuma Blockchain Platform
//
// Copyright (c) 2017 Enuma Technologies.
// https://www.enuma.io/
// ----------------------------------------------------------------------------


// BK Ok
import "./Owned.sol";


//
// Implements a security model with owner and ops.
//
// BK Ok
contract OpsManaged is Owned {

   // BK Ok
   address public opsAddress;

   // BK Ok - Event
   event OpsAddressUpdated(address indexed _newAddress);


   // BK Ok - Constructor
   function OpsManaged() public
      Owned()
   {
   }


   // BK Ok
   modifier onlyOwnerOrOps() {
      // BK Ok
      require(isOwnerOrOps(msg.sender));
      // BK Ok
      _;
   }


   // BK Ok - Constant function
   function isOps(address _address) public view returns (bool) {
      // BK Ok
      return (opsAddress != address(0) && _address == opsAddress);
   }


   // BK Ok - Constant function
   function isOwnerOrOps(address _address) public view returns (bool) {
      // BK Ok
      return (isOwner(_address) || isOps(_address));
   }


   // BK Ok - Only owner can execute
   function setOpsAddress(address _newOpsAddress) public onlyOwner returns (bool) {
      // BK Next 2 Ok
      require(_newOpsAddress != owner);
      require(_newOpsAddress != address(this));

      // BK Ok
      opsAddress = _newOpsAddress;

      // BK Ok - Log event
      OpsAddressUpdated(opsAddress);

      // BK Ok
      return true;
   }
}

```
