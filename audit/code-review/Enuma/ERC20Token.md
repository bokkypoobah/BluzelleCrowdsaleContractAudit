# ERC20Token

Source file [../../../contracts/Enuma/ERC20Token.sol](../../../contracts/Enuma/ERC20Token.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------
// ERC20Token - Standard ERC20 Implementation
// Enuma Blockchain Platform
//
// Copyright (c) 2017 Enuma Technologies.
// https://www.enuma.io/
// ----------------------------------------------------------------------------

// BK Ok
import "./ERC20Interface.sol";
import "./Math.sol";


// BK Ok
contract ERC20Token is ERC20Interface {

   // BK Ok
   using Math for uint256;

   // BK Next 4 Ok
   string  private tokenName;
   string  private tokenSymbol;
   uint8   private tokenDecimals;
   uint256 internal tokenTotalSupply;

   // BK Next 2 Ok
   mapping(address => uint256) internal balances;
   mapping(address => mapping (address => uint256)) allowed;


   // BK Ok - Constructor
   function ERC20Token(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply, address _initialTokenHolder) public {
      // BK Next 4 Ok
      tokenName = _name;
      tokenSymbol = _symbol;
      tokenDecimals = _decimals;
      tokenTotalSupply = _totalSupply;

      // The initial balance of tokens is assigned to the given token holder address.
      // BK Ok
      balances[_initialTokenHolder] = _totalSupply;

      // Per EIP20, the constructor should fire a Transfer event if tokens are assigned to an account.
      // BK Ok - Log event
      Transfer(0x0, _initialTokenHolder, _totalSupply);
   }


   // BK Ok - View function
   function name() public view returns (string) {
      // BK Ok
      return tokenName;
   }


   // BK Ok - View function
   function symbol() public view returns (string) {
      // BK Ok
      return tokenSymbol;
   }


   // BK Ok - View function
   function decimals() public view returns (uint8) {
      // BK Ok
      return tokenDecimals;
   }


   // BK Ok - View function
   function totalSupply() public view returns (uint256) {
      // BK Ok
      return tokenTotalSupply;
   }


   // BK Ok - View function
   function balanceOf(address _owner) public view returns (uint256 balance) {
      // BK Ok
      return balances[_owner];
   }


   // BK Ok - View function
   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
      // BK Ok
      return allowed[_owner][_spender];
   }


   // BK Ok
   function transfer(address _to, uint256 _value) public returns (bool success) {
      // BK Ok
      balances[msg.sender] = balances[msg.sender].sub(_value);
      // BK Ok
      balances[_to] = balances[_to].add(_value);

      // BK Ok - Log event
      Transfer(msg.sender, _to, _value);

      // BK Ok
      return true;
   }


   // BK Ok
   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
      // BK Ok
      balances[_from] = balances[_from].sub(_value);
      // BK Ok
      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
      // BK Ok
      balances[_to] = balances[_to].add(_value);

      // BK Ok - Log event
      Transfer(_from, _to, _value);

      // BK Ok
      return true;
   }


   // BK Ok
   function approve(address _spender, uint256 _value) public returns (bool success) {
      // BK Ok
      allowed[msg.sender][_spender] = _value;

      // BK Ok - Log event
      Approval(msg.sender, _spender, _value);

      // BK Ok
      return true;
   }
}

```
