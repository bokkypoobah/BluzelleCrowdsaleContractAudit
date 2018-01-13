# BluzelleTokenSaleConfig

Source file [../../contracts/BluzelleTokenSaleConfig.sol](../../contracts/BluzelleTokenSaleConfig.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------
// BluzelleTokenSaleConfig - Token Sale Configuration
//
// Copyright (c) 2017 Bluzelle Networks Pte Ltd.
// http://www.bluzelle.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

// BK Ok
import "./BluzelleTokenConfig.sol";


// BK Ok
contract BluzelleTokenSaleConfig is BluzelleTokenConfig {

    //
    // Time
    //
    // BK Ok - new Date(1511870400 * 1000).toUTCString() => "Tue, 28 Nov 2017 12:00:00 UTC"
    uint256 public constant INITIAL_STARTTIME      = 1511870400; // 2017-11-28, 12:00:00 UTC
    // BK Ok - new Date(1512043200 * 1000).toUTCString() => "Thu, 30 Nov 2017 12:00:00 UTC"
    uint256 public constant INITIAL_ENDTIME        = 1512043200; // 2017-11-30, 12:00:00 UTC
    // BK Ok
    uint256 public constant INITIAL_STAGE          = 1;


    //
    // Purchases
    //

    // Minimum amount of ETH that can be used for purchase.
    // BK Ok
    uint256 public constant CONTRIBUTION_MIN      = 0.1 ether;

    // Price of tokens, based on the 1 ETH = 1700 BLZ conversion ratio.
    // BK Ok
    uint256 public constant TOKENS_PER_KETHER     = 1700000;

    // Amount of bonus applied to the sale. 2000 = 20.00% bonus, 750 = 7.50% bonus, 0 = no bonus.
    // BK Ok
    uint256 public constant BONUS                 = 2000;

    // Maximum amount of tokens that can be purchased for each account.
    // BK Ok
    uint256 public constant TOKENS_ACCOUNT_MAX    = 17000 * DECIMALSFACTOR;
}


```
