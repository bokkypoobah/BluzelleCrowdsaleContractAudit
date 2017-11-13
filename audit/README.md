# Bluzelle Crowdsale Contract Audit

Status: Work in progress

## Summary

[Bluzelle](https://bluzelle.com/) intends to run a crowdsale commencing in Nov 2017.

Bok Consulting Pty Ltd was commissioned to perform an audit on the Bluzelle's crowdsale and token Ethereum smart contract.

This audit has been conducted on Bluzelle's source code in commits
[108639e](https://github.com/njmurarka/ico-solidity/commit/108639ea9fa9299c4324ae11f5bbfc480596730e) and
[50f7efd](https://github.com/njmurarka/ico-solidity/commit/50f7efd4029bec6469449f9d388e7e729a1a892c).

TODO: Check - No potential vulnerabilities have been identified in the crowdsale and token contract.


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

<br />

<hr />

## Potential Vulnerabilities

TODO: Check - No potential vulnerabilities have been identified in the crowdsale and token contract.

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

TODO

<br />

<hr />

## Testing

<br />

<hr />

## Code Review

* [x] [code-review/Owned.md](code-review/Owned.md)
  * [x] contract Owned
* [x] [code-review/OpsManaged.md](code-review/OpsManaged.md)
  * [x] contract OpsManaged is Owned
* [ ] [code-review/BluzelleToken.md](code-review/BluzelleToken.md)
  * [ ] contract BluzelleToken is FinalizableToken, BluzelleTokenConfig
* [ ] [code-review/BluzelleTokenConfig.md](code-review/BluzelleTokenConfig.md)
  * [ ] contract BluzelleTokenConfig
* [ ] [code-review/BluzelleTokenSale.md](code-review/BluzelleTokenSale.md)
  * [ ] contract BluzelleTokenSale is FlexibleTokenSale, BluzelleTokenSaleConfig
* [ ] [code-review/BluzelleTokenSaleConfig.md](code-review/BluzelleTokenSaleConfig.md)
  * [ ] contract BluzelleTokenSaleConfig is BluzelleTokenConfig
* [ ] [code-review/BluzelleTokenSaleMock.md](code-review/BluzelleTokenSaleMock.md)
  * [ ] contract BluzelleTokenSaleMock is BluzelleTokenSale
* [ ] [code-review/ERC20Interface.md](code-review/ERC20Interface.md)
  * [ ] contract ERC20Interface
* [ ] [code-review/ERC20Token.md](code-review/ERC20Token.md)
  * [ ] contract ERC20Token is ERC20Interface
* [ ] [code-review/Finalizable.md](code-review/Finalizable.md)
  * [ ] contract Finalizable is Owned
* [ ] [code-review/FinalizableToken.md](code-review/FinalizableToken.md)
  * [ ] contract FinalizableToken is ERC20Token, OpsManaged, Finalizable
* [ ] [code-review/FlexibleTokenSale.md](code-review/FlexibleTokenSale.md)
  * [ ] contract FlexibleTokenSale is Finalizable, OpsManaged
* [ ] [code-review/FlexibleTokenSaleMock.md](code-review/FlexibleTokenSaleMock.md)
  * [ ] contract FlexibleTokenSaleMock is FlexibleTokenSale
* [ ] [code-review/Math.md](code-review/Math.md)
  * [ ] library Math
* [ ] [code-review/MathTest.md](code-review/MathTest.md)
  * [ ] contract MathTest

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd for Bluzelle - Nov 13 2017. The MIT Licence.
