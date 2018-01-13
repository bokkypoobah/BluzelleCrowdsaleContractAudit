# FlexibleTokenSale

Source file [../../../contracts/Enuma/FlexibleTokenSale.sol](../../../contracts/Enuma/FlexibleTokenSale.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------
// FlexibleTokenSale - Token Sale Contract
// Enuma Blockchain Platform
//
// Copyright (c) 2017 Enuma Technologies.
// https://www.enuma.io/
// ----------------------------------------------------------------------------

// BK Next 4 Ok
import "./FinalizableToken.sol";
import "./Finalizable.sol";
import "./OpsManaged.sol";
import "./Math.sol";


// BK Ok
contract FlexibleTokenSale is Finalizable, OpsManaged {

   // BK Ok
   using Math for uint256;

   //
   // Lifecycle
   //
   // BK Next 3 Ok
   uint256 public startTime;
   uint256 public endTime;
   bool public suspended;

   //
   // Pricing
   //
   // BK Next 5 Ok
   uint256 public tokensPerKEther;
   uint256 public bonus;
   uint256 public maxTokensPerAccount;
   uint256 public contributionMin;
   uint256 public tokenConversionFactor;

   //
   // Wallets
   //
   // BK Ok
   address public walletAddress;

   //
   // Token
   //
   // BK Ok
   FinalizableToken public token;

   //
   // Counters
   //
   // BK Next 2 Ok
   uint256 public totalTokensSold;
   uint256 public totalEtherCollected;


   //
   // Events
   //
   // BK Next 10 Ok
   event Initialized();
   event TokensPerKEtherUpdated(uint256 _newValue);
   event MaxTokensPerAccountUpdated(uint256 _newMax);
   event BonusUpdated(uint256 _newValue);
   event SaleWindowUpdated(uint256 _startTime, uint256 _endTime);
   event WalletAddressUpdated(address _newAddress);
   event SaleSuspended();
   event SaleResumed();
   event TokensPurchased(address _beneficiary, uint256 _cost, uint256 _tokens);
   event TokensReclaimed(uint256 _amount);


   // BK Ok - Constructor
   function FlexibleTokenSale(uint256 _startTime, uint256 _endTime, address _walletAddress) public
      OpsManaged()
   {
      // BK Ok
      require(_endTime > _startTime);

      // BK Next 2 Ok
      require(_walletAddress != address(0));
      require(_walletAddress != address(this));

      // BK Ok
      walletAddress = _walletAddress;

      // BK Next 2 Ok
      finalized = false;
      suspended = false;

      // BK Next 2 Ok
      startTime = _startTime;
      endTime   = _endTime;

      // Use some defaults config values. Classes deriving from FlexibleTokenSale
      // should set their own defaults
      // BK Next 2 Ok
      tokensPerKEther     = 100000;
      // BK Ok
      bonus               = 0;
      // BK Ok
      maxTokensPerAccount = 0;
      // BK Ok
      contributionMin     = 0.1 ether;

      // BK Next 2 Ok
      totalTokensSold     = 0;
      totalEtherCollected = 0;
   }


   // BK Ok - Constant function
   function currentTime() public constant returns (uint256) {
      // BK Ok
      return now;
   }


   // Initialize should be called by the owner as part of the deployment + setup phase.
   // It will associate the sale contract with the token contract and perform basic checks.
   // BK Ok - Only owner can execute
   function initialize(FinalizableToken _token) external onlyOwner returns(bool) {
      // BK Ok
      require(address(token) == address(0));
      // BK Next 3 Ok
      require(address(_token) != address(0));
      require(address(_token) != address(this));
      require(address(_token) != address(walletAddress));
      // BK Ok
      require(isOwnerOrOps(address(_token)) == false);

      // BK Ok
      token = _token;

      // This factor is used when converting cost <-> tokens.
      // 18 is because of the ETH -> Wei conversion.
      // 3 because prices are in K ETH instead of just ETH.
      // 4 because bonuses are expressed as 0 - 10000 for 0.00% - 100.00% (with 2 decimals).
      tokenConversionFactor = 10**(uint256(18).sub(_token.decimals()).add(3).add(4));
      // BK Ok
      require(tokenConversionFactor > 0);

      // BK Ok - Log event
      Initialized();

      // BK Ok
      return true;
   }


   //
   // Owner Configuation
   //

   // Allows the owner to change the wallet address which is used for collecting
   // ether received during the token sale.
   // BK Ok - Only owner can execute
   function setWalletAddress(address _walletAddress) external onlyOwner returns(bool) {
      // BK Next 3 Ok
      require(_walletAddress != address(0));
      require(_walletAddress != address(this));
      require(_walletAddress != address(token));
      // BK Ok
      require(isOwnerOrOps(_walletAddress) == false);

      // BK Ok
      walletAddress = _walletAddress;

      // BK Ok - Log event
      WalletAddressUpdated(_walletAddress);

      // BK Ok
      return true;
   }


   // Allows the owner to set an optional limit on the amount of tokens that can be purchased
   // by a contributor. It can also be set to 0 to remove limit.
   // BK Ok - Only owner can execute
   function setMaxTokensPerAccount(uint256 _maxTokens) external onlyOwner returns(bool) {

      // BK Ok
      maxTokensPerAccount = _maxTokens;

      // BK Ok - Log event
      MaxTokensPerAccountUpdated(_maxTokens);

      // BK Ok
      return true;
   }


   // Allows the owner to specify the conversion rate for ETH -> tokens.
   // For example, passing 1,000,000 would mean that 1 ETH would purchase 1000 tokens.
   // BK Ok - Only owner can execute
   function setTokensPerKEther(uint256 _tokensPerKEther) external onlyOwner returns(bool) {
      // BK Ok
      require(_tokensPerKEther > 0);

      // BK Ok
      tokensPerKEther = _tokensPerKEther;

      // BK Ok - Log event
      TokensPerKEtherUpdated(_tokensPerKEther);

      // BK Ok
      return true;
   }


   // Allows the owner to set a bonus to apply to all purchases.
   // For example, setting it to 2000 means that instead of receiving 200 tokens,
   // for a given price, contributors would receive 240 tokens (20.00% bonus).
   function setBonus(uint256 _bonus) external onlyOwner returns(bool) {
      require(_bonus <= 10000);

      // BK Ok
      bonus = _bonus;

      // BK Ok - Log event
      BonusUpdated(_bonus);

      // BK Ok
      return true;
   }


   // Allows the owner to set a sale window which will allow the sale (aka buyTokens) to
   // receive contributions between _startTime and _endTime. Once _endTime is reached,
   // the sale contract will automatically stop accepting incoming contributions.
   // BK Ok - Only owner can execute
   function setSaleWindow(uint256 _startTime, uint256 _endTime) external onlyOwner returns(bool) {
      // BK Ok
      require(_startTime > 0);
      // BK Ok
      require(_endTime > _startTime);

      // BK Next 2 Ok
      startTime = _startTime;
      endTime   = _endTime;

      // BK Ok - Log event
      SaleWindowUpdated(_startTime, _endTime);

      // BK Ok
      return true;
   }


   // Allows the owner to suspend the sale until it is manually resumed at a later time.
   // BK Ok - Only owner can execute
   function suspend() external onlyOwner returns(bool) {
      // BK Ok
      if (suspended == true) {
          // BK Ok
          return false;
      }

      // BK Ok
      suspended = true;

      // BK Ok - Log event
      SaleSuspended();

      // BK Ok
      return true;
   }


   // Allows the owner to resume the sale.
   // BK Ok - Only owner can execute
   function resume() external onlyOwner returns(bool) {
      // BK Ok
      if (suspended == false) {
          // BK Ok
          return false;
      }

      // BK Ok
      suspended = false;

      // BK Ok - Log event
      SaleResumed();

      // BK Ok
      return true;
   }


   //
   // Contributions
   //

   // Default payable function which can be used to purchase tokens.
   // BK Ok - Anyone can contribute ETH
   function () payable public {
      // BK Ok
      buyTokens(msg.sender);
   }


   // Allows the caller to purchase tokens for a specific beneficiary (proxy purchase).
   // BK Ok
   function buyTokens(address _beneficiary) public payable returns (uint256) {
      // BK Ok
      return buyTokensInternal(_beneficiary, bonus);
   }


   // BK Ok
   function buyTokensInternal(address _beneficiary, uint256 _bonus) internal returns (uint256) {
      // BK Next 8 Ok
      require(!finalized);
      require(!suspended);
      require(currentTime() >= startTime);
      require(currentTime() <= endTime);
      require(msg.value >= contributionMin);
      require(_beneficiary != address(0));
      require(_beneficiary != address(this));
      require(_beneficiary != address(token));

      // We don't want to allow the wallet collecting ETH to
      // directly be used to purchase tokens.
      // BK Ok
      require(msg.sender != address(walletAddress));

      // Check how many tokens are still available for sale.
      // BK Ok
      uint256 saleBalance = token.balanceOf(address(this));
      // BK Ok
      require(saleBalance > 0);

      // Calculate how many tokens the contributor could purchase based on ETH received.
      // BK Ok
      uint256 tokens = msg.value.mul(tokensPerKEther).mul(_bonus.add(10000)).div(tokenConversionFactor);
      // BK Ok
      require(tokens > 0);

      // BK Ok
      uint256 cost = msg.value;
      // BK Ok
      uint256 refund = 0;

      // Calculate what is the maximum amount of tokens that the contributor
      // should be allowed to purchase
      // BK Ok
      uint256 maxTokens = saleBalance;

      // BK Ok
      if (maxTokensPerAccount > 0) {
         // There is a maximum amount of tokens per account in place.
         // Check if the user already hit that limit.
         // BK Ok
         uint256 userBalance = getUserTokenBalance(_beneficiary);
         // BK Ok
         require(userBalance < maxTokensPerAccount);

         // BK Ok
         uint256 quotaBalance = maxTokensPerAccount.sub(userBalance);

         // BK Ok
         if (quotaBalance < saleBalance) {
            // BK Ok
            maxTokens = quotaBalance;
         }
      }

      // BK Ok
      require(maxTokens > 0);

      // BK Ok
      if (tokens > maxTokens) {
         // The contributor sent more ETH than allowed to purchase.
         // Limit the amount of tokens that they can purchase in this transaction.
         // BK Ok
         tokens = maxTokens;

         // Calculate the actual cost for that new amount of tokens.
         // BK Ok
         cost = tokens.mul(tokenConversionFactor).div(tokensPerKEther.mul(_bonus.add(10000)));

         // BK Ok
         if (msg.value > cost) {
            // If the contributor sent more ETH than needed to buy the tokens,
            // the balance should be refunded.
            // BK Ok
            refund = msg.value.sub(cost);
         }
      }

      // This is the actual amount of ETH that can be sent to the wallet.
      // BK Ok
      uint256 contribution = msg.value.sub(refund);
      // BK Ok
      walletAddress.transfer(contribution);

      // Update our stats counters.
      // BK Ok
      totalTokensSold     = totalTokensSold.add(tokens);
      // BK Ok
      totalEtherCollected = totalEtherCollected.add(contribution);

      // Transfer tokens to the beneficiary.
      // BK Ok
      require(token.transfer(_beneficiary, tokens));

      // Issue a refund for the excess ETH, as needed.
      // BK Ok
      if (refund > 0) {
         // BK Ok
         msg.sender.transfer(refund);
      }

      // BK Ok - Log event
      TokensPurchased(_beneficiary, cost, tokens);

      // BK Ok
      return tokens;
   }


   // Returns the number of tokens that the user has purchased. Will be checked against the
   // maximum allowed. Can be overriden in a sub class to change the calculations.
   // BK Ok - Internal view function
   function getUserTokenBalance(address _beneficiary) internal view returns (uint256) {
      // BK Ok
      return token.balanceOf(_beneficiary);
   }


   // Allows the owner to take back the tokens that are assigned to the sale contract.
   // BK Ok - Only owner can execute
   function reclaimTokens() external onlyOwner returns (bool) {
      // BK Ok
      uint256 tokens = token.balanceOf(address(this));

      // BK Ok
      if (tokens == 0) {
         // BK Ok
         return false;
      }

      // BK Ok
      address tokenOwner = token.owner();
      // BK Ok
      require(tokenOwner != address(0));

      // BK Ok
      require(token.transfer(tokenOwner, tokens));

      // BK Ok - Log event
      TokensReclaimed(tokens);

      // BK Ok
      return true;
   }
}


```
