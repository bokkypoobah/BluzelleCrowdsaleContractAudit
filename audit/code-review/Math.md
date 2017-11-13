# Math

Source file [../../contracts/Math.sol](../../contracts/Math.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// Math - General Math Utility Library
// Enuma Blockchain Framework
//
// Copyright (c) 2017 Enuma Technologies.
// http://www.enuma.io/
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
