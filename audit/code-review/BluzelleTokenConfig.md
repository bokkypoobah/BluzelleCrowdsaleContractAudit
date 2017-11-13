# BluzelleTokenConfig

Source file [../../contracts/BluzelleTokenConfig.sol](../../contracts/BluzelleTokenConfig.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// BluzelleTokenConfig - Token Contract Configuration
//
// Copyright (c) 2017 Bluzelle Networks Pte Ltd.
// http://www.bluzelle.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------


// BK Ok
contract BluzelleTokenConfig {

    // BK Next 3 Ok
    string  public constant TOKEN_SYMBOL      = "BLZ";
    string  public constant TOKEN_NAME        = "Bluzelle Token";
    uint8   public constant TOKEN_DECIMALS    = 18;

    // BK Ok
    uint256 public constant DECIMALSFACTOR    = 10**uint256(TOKEN_DECIMALS);
    // BK Ok
    uint256 public constant TOKEN_TOTALSUPPLY = 500000000 * DECIMALSFACTOR;
}


```
