# BluzelleTokenSale

Source file [../../contracts/BluzelleTokenSale.sol](../../contracts/BluzelleTokenSale.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------
// BluzelleTokenSale - Token Sale Contract
//
// Copyright (c) 2017 Bluzelle Networks Pte Ltd.
// http://www.bluzelle.com/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

// BK Next 2 Ok
import "./Enuma/FlexibleTokenSale.sol";
import "./BluzelleTokenSaleConfig.sol";


// BK Ok
contract BluzelleTokenSale is FlexibleTokenSale, BluzelleTokenSaleConfig {

   //
   // Whitelist
   //

   // This is the stage or whitelist group that is currently in effect.
   // Everybody that's been whitelisted for earlier stages should be able to
   // contribute in the current stage.
   // BK Ok
   uint256 public currentStage;

   // Keeps track of the amount of bonus to apply for a given stage. If set
   // to 0, the base class bonus will be used.
   // BK Ok
   mapping(uint256 => uint256) public stageBonus;

   // Keeps track of the amount of tokens that a specific account has received.
   // BK Ok
   mapping(address => uint256) public accountTokensPurchased;

   // This a mapping of address -> stage that they are allowed to participate in.
   // For example, if someone has been whitelisted for stage 2, they will be able
   // to participate for stages 2 and above but they would not be able to participate
   // in stage 1. A stage value of 0 means that the participant is not whitelisted.
   // BK Ok
   mapping(address => uint256) public whitelist;


   //
   // Events
   //
   // BK Next 3 Ok - Events
   event CurrentStageUpdated(uint256 _newStage);
   event StageBonusUpdated(uint256 _stage, uint256 _bonus);
   event WhitelistedStatusUpdated(address indexed _address, uint256 _stage);


   // BK Ok - Constructor
   function BluzelleTokenSale(address wallet) public
      FlexibleTokenSale(INITIAL_STARTTIME, INITIAL_ENDTIME, wallet)
   {
      // BK Next 5 Ok
      currentStage        = INITIAL_STAGE;
      tokensPerKEther     = TOKENS_PER_KETHER;
      bonus               = BONUS;
      maxTokensPerAccount = TOKENS_ACCOUNT_MAX;
      contributionMin     = CONTRIBUTION_MIN;
   }


   // Allows the admin to determine what is the current stage for
   // the sale. It can only move forward.
   // BK Ok - Only owner can execute
   function setCurrentStage(uint256 _stage) public onlyOwner returns(bool) {
      // BK Ok
      require(_stage > 0);

      // BK Ok
      if (currentStage == _stage) {
         // BK Ok
         return false;
      }

      // BK Ok
      currentStage = _stage;

      // BK Ok - Log event
      CurrentStageUpdated(_stage);

      return true;
   }


   // Allows the admin to set a bonus amount to apply for a specific stage.
   // BK Ok - Only owner can execute
   function setStageBonus(uint256 _stage, uint256 _bonus) public onlyOwner returns(bool) {
      // BK Ok
      require(_stage > 0);
      // BK Ok
      require(_bonus <= 10000);

      // BK Ok
      if (stageBonus[_stage] == _bonus) {
         // Nothing to change.
         // BK Ok
         return false;
      }

      // BK Ok
      stageBonus[_stage] = _bonus;

      // BK Ok - Log event
      StageBonusUpdated(_stage, _bonus);

      // BK Ok
      return true;
   }


   // Allows the owner or ops to add/remove people from the whitelist.
   // BK Ok - Only owner or ops can execute
   function setWhitelistedStatus(address _address, uint256 _stage) public onlyOwnerOrOps returns (bool) {
      // BK Ok
      return setWhitelistedStatusInternal(_address, _stage);
   }


   // BK Ok - Private function
   function setWhitelistedStatusInternal(address _address, uint256 _stage) private returns (bool) {
      // BK Ok
      require(_address != address(0));
      // BK Ok
      require(_address != address(this));
      // BK Ok
      require(_address != walletAddress);

      // BK Ok
      whitelist[_address] = _stage;

      // BK Ok - Log event
      WhitelistedStatusUpdated(_address, _stage);

      // BK Ok
      return true;
   }


   // Allows the owner or ops to add/remove people from the whitelist, in batches. This makes
   // it easier/cheaper/faster to upload whitelist data in bulk. Note that the function is using an
   // unbounded loop so the call should take care to not exceed the tx gas limit or block gas limit.
   // BK Ok - Only owner or ops can execute
   function setWhitelistedBatch(address[] _addresses, uint256 _stage) public onlyOwnerOrOps returns (bool) {
      // BK Ok
      require(_addresses.length > 0);

      // BK Ok
      for (uint256 i = 0; i < _addresses.length; i++) {
         // BK Ok
         require(setWhitelistedStatusInternal(_addresses[i], _stage));
      }

      // BK Ok
      return true;
   }


   // This is an extension to the buyToken function in FlexibleTokenSale which also takes
   // care of checking contributors against the whitelist. Since buyTokens supports proxy payments
   // we check that both the sender and the beneficiary have been whitelisted.
   // BK Ok - Internal function
   function buyTokensInternal(address _beneficiary, uint256 _bonus) internal returns (uint256) {
      // BK Ok
      require(whitelist[msg.sender] > 0);
      // BK Ok
      require(whitelist[_beneficiary] > 0);
      // BK Ok
      require(currentStage >= whitelist[msg.sender]);

      // BK Ok
      uint256 _beneficiaryStage = whitelist[_beneficiary];
      // BK Ok
      require(currentStage >= _beneficiaryStage);

      // BK Ok
      uint256 applicableBonus = stageBonus[_beneficiaryStage];
      // BK Ok
      if (applicableBonus == 0) {
         // BK Ok
         applicableBonus = _bonus;
      }

      // BK Ok
      uint256 tokensPurchased = super.buyTokensInternal(_beneficiary, applicableBonus);

      // BK Ok
      accountTokensPurchased[_beneficiary] = accountTokensPurchased[_beneficiary].add(tokensPurchased);

      // BK Ok
      return tokensPurchased;
   }


   // Returns the number of tokens that the user has purchased. We keep a separate balance from
   // the token contract in case we'd like to do additional sales with new purchase limits. This behavior
   // is different from the base implementation which just checks the token balance from the token
   // contract directly.
   // BK Ok
   function getUserTokenBalance(address _beneficiary) internal view returns (uint256) {
      // BK Ok
      return accountTokensPurchased[_beneficiary];
   }
}


```
