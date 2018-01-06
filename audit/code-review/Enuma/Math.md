# Math

Source file [../../../contracts/Enuma/Math.sol](../../../contracts/Enuma/Math.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------
// Math - General Math Utility Library
// Enuma Blockchain Platform
//
// Copyright (c) 2017 Enuma Technologies.
// https://www.enuma.io/
// ----------------------------------------------------------------------------


// BK Ok
library Math {

   // BK Ok - Pure function
   function add(uint256 a, uint256 b) internal pure returns (uint256) {
      // BK Ok
      uint256 r = a + b;

      // BK Ok
      require(r >= a);

      // BK Ok
      return r;
   }


   // BK Ok - Pure function
   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      // BK Ok
      require(a >= b);

      // BK Ok
      return a - b;
   }


   // BK Ok - Pure function
   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
      // BK Ok
      uint256 r = a * b;

      // BK Ok
      require(a == 0 || r / a == b);

      // BK Ok
      return r;
   }


   // BK Ok - Pure function
   function div(uint256 a, uint256 b) internal pure returns (uint256) {
      // BK Ok
      return a / b;
   }
}

```
