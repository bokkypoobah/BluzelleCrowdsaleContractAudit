# Bluzelle Crowdsale Contract Audit

## Summary

[Bluzelle](https://bluzelle.com/) intends to run a crowdsale commencing in Jan 2018.

Bok Consulting Pty Ltd was commissioned to perform an audit on the Bluzelle's crowdsale and token Ethereum smart contract.

This audit has been conducted on Bluzelle's source code in commits
[108639e](https://github.com/njmurarka/ico-solidity/commit/108639ea9fa9299c4324ae11f5bbfc480596730e),
[50f7efd](https://github.com/njmurarka/ico-solidity/commit/50f7efd4029bec6469449f9d388e7e729a1a892c),
[542b5ca](https://github.com/njmurarka/ico-solidity/commit/542b5ca38d7cfc2292e1bb135b8ee10679e54d23) and
[01df595](https://github.com/njmurarka/ico-solidity/commit/01df595e1204e321a23331941b853e4a85e00ef9).

No potential vulnerabilities have been identified in the crowdsale and token contract.

<br />

### Mainnet Contract Details

`TBA`

<br />

### Crowdsale Contract

The crowdsale contract receives ethers (ETH) from participants and generates BLZ tokens assigned to the participant's account. The contributed ETH
used to purchase the tokens is immediately transferred to the crowdsale wallet. And excess ETH above the contribution limits is refunded to the
participant's account.

<br />

### Token Contract

The token contract is compliant with the recently finalised [ERC20 Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md),
with the following notable features:

* `transfer(...)` and `transferFrom(...)` will `REVERT` if there is insufficient balance (or approved amount)
* 0 value `transfer(...)` and `transferFrom(...)` are valid transfers
* `approve(...)` does not require a non-0 allowance to be set to 0 before being set to a different non-0 amount

<br />

<hr />

## Table Of Contents

* [Summary](#summary)
* [Recommendations](#recommendations)
* [Potential Vulnerabilities](#potential-vulnerabilities)
* [Scope](#scope)
* [Limitations](#limitations)
* [Due Diligence](#due-diligence)
* [Risks](#risks)
* [Testing](#testing)
* [Code Review](#code-review)

<br />

<hr />

## Recommendations

* [x] **LOW IMPORTANCE** `BluzelleToken.reclaimTokens()` should emit a `Transfer(...)` event as this is picked up by blockchain
  token explorers
  [x] `Transfer(...)` event added in [01df595](https://github.com/njmurarka/ico-solidity/commit/01df595e1204e321a23331941b853e4a85e00ef9)

<br />

<hr />

## Potential Vulnerabilities

No potential vulnerabilities have been identified in the crowdsale and token contract.

<br />

<hr />

## Scope

This audit is into the technical aspects of the crowdsale contracts. The primary aim of this audit is to ensure that funds
contributed to these contracts are not easily attacked or stolen by third parties. The secondary aim of this audit is that
ensure the coded algorithms work as expected. This audit does not guarantee that that the code is bugfree, but intends to
highlight any areas of weaknesses.

<br />

<hr />

## Limitations

This audit makes no statements or warranties about the viability of the Bluzelle's business proposition, the individuals
involved in this business or the regulatory regime for the business model.

<br />

<hr />

## Due Diligence

As always, potential participants in any crowdsale are encouraged to perform their due diligence on the business proposition
before funding any crowdsales.

Potential participants are also encouraged to only send their funds to the official crowdsale Ethereum address, published on
the crowdsale beneficiary's official communication channel.

Scammers have been publishing phishing address in the forums, twitter and other communication channels, and some go as far as
duplicating crowdsale websites. Potential participants should NOT just click on any links received through these messages.
Scammers have also hacked the crowdsale website to replace the crowdsale contract address with their scam address.
 
Potential participants should also confirm that the verified source code on EtherScan.io for the published crowdsale address
matches the audited source code, and that the deployment parameters are correctly set, including the constant parameters.

<br />

<hr />

## Risks

* This crowdsale contract has a low risk of having the ETH hacked or stolen, as any contributions by participants are immediately transferred
  to the crowdsale wallet

<br />

<hr />

## Testing

The following functions were tested using the script [test/01_test1.sh](test/01_test1.sh) with the summary results saved
in [test/test1results.txt](test/test1results.txt) and the detailed output saved in [test/test1output.txt](test/test1output.txt):

* [x] Deploy token contract
* [x] Deploy sale contract
* [x] Initialise sale contract
* [x] Whitelist addresses
* [x] Send contributions and receive tokens
* [x] Finalise sale
* [x] `transfer(...)` and `transferFrom(...)` tokens

<br />

<hr />

## Code Review

### contracts/Enuma

* [x] [code-review/Math.md](code-review/Math.md)
  * [x] library Math
* [x] [code-review/Owned.md](code-review/Owned.md)
  * [x] contract Owned
    * [x] Small functional update in [542b5ca](https://github.com/njmurarka/ico-solidity/commit/542b5ca38d7cfc2292e1bb135b8ee10679e54d23)
* [x] [code-review/OpsManaged.md](code-review/OpsManaged.md)
  * [x] contract OpsManaged is Owned
* [x] [code-review/ERC20Interface.md](code-review/ERC20Interface.md)
  * [x] contract ERC20Interface
* [x] [code-review/ERC20Token.md](code-review/ERC20Token.md)
  * [x] contract ERC20Token is ERC20Interface
* [x] [code-review/Finalizable.md](code-review/Finalizable.md)
  * [x] contract Finalizable is Owned
    * [x] Small functional update in [542b5ca](https://github.com/njmurarka/ico-solidity/commit/542b5ca38d7cfc2292e1bb135b8ee10679e54d23)
* [x] [code-review/FinalizableToken.md](code-review/FinalizableToken.md)
  * [x] contract FinalizableToken is ERC20Token, OpsManaged, Finalizable
* [x] [code-review/FlexibleTokenSale.md](code-review/FlexibleTokenSale.md)
  * [x] contract FlexibleTokenSale is Finalizable, OpsManaged
    * [x] Functional update in [542b5ca](https://github.com/njmurarka/ico-solidity/commit/542b5ca38d7cfc2292e1bb135b8ee10679e54d23)

<br />

### contracts

* [x] [code-review/BluzelleTokenConfig.md](code-review/BluzelleTokenConfig.md)
  * [x] contract BluzelleTokenConfig
* [x] [code-review/BluzelleToken.md](code-review/BluzelleToken.md)
  * [x] contract BluzelleToken is FinalizableToken, BluzelleTokenConfig
    * [x] Functional update in [542b5ca](https://github.com/njmurarka/ico-solidity/commit/542b5ca38d7cfc2292e1bb135b8ee10679e54d23)
    * [x] `Transfer(...)` event added in [01df595](https://github.com/njmurarka/ico-solidity/commit/01df595e1204e321a23331941b853e4a85e00ef9)
* [x] [code-review/BluzelleTokenSaleConfig.md](code-review/BluzelleTokenSaleConfig.md)
  * [x] contract BluzelleTokenSaleConfig is BluzelleTokenConfig
    * [x] Functional update in [542b5ca](https://github.com/njmurarka/ico-solidity/commit/542b5ca38d7cfc2292e1bb135b8ee10679e54d23)
* [x] [code-review/BluzelleTokenSale.md](code-review/BluzelleTokenSale.md)
  * [x] contract BluzelleTokenSale is FlexibleTokenSale, BluzelleTokenSaleConfig

<br />

### Not Reviewed

The following was not review as it is only used for testing:

* [ ] [../contracts/Enuma/MathTest.sol](../contracts/Enuma/MathTest.sol)
  * [ ] contract MathTest
* [ ] [../contracts/Enuma/FlexibleTokenSaleMock.sol](../contracts/Enuma/FlexibleTokenSaleMock.sol)
  * [ ] contract FlexibleTokenSaleMock is FlexibleTokenSale
* [ ] [../contracts/BluzelleTokenSaleMock.sol](../contracts/BluzelleTokenSaleMock.sol)
  * [ ] contract BluzelleTokenSaleMock is BluzelleTokenSale

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd for Bluzelle - Jan 14 2018. The MIT Licence.