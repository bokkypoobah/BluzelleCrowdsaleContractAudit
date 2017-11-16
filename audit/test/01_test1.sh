#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

MODE=${1:-test}

GETHATTACHPOINT=`grep ^IPCFILE= settings.txt | sed "s/^.*=//"`
PASSWORD=`grep ^PASSWORD= settings.txt | sed "s/^.*=//"`

CONTRACTSDIR=`grep ^CONTRACTSDIR= settings.txt | sed "s/^.*=//"`

TOKENSOL=`grep ^TOKENSOL= settings.txt | sed "s/^.*=//"`
TOKENJS=`grep ^TOKENJS= settings.txt | sed "s/^.*=//"`

SALESOL=`grep ^SALESOL= settings.txt | sed "s/^.*=//"`
SALEJS=`grep ^SALEJS= settings.txt | sed "s/^.*=//"`

DEPLOYMENTDATA=`grep ^DEPLOYMENTDATA= settings.txt | sed "s/^.*=//"`

INCLUDEJS=`grep ^INCLUDEJS= settings.txt | sed "s/^.*=//"`
TEST1OUTPUT=`grep ^TEST1OUTPUT= settings.txt | sed "s/^.*=//"`
TEST1RESULTS=`grep ^TEST1RESULTS= settings.txt | sed "s/^.*=//"`

CURRENTTIME=`date +%s`
CURRENTTIMES=`date -r $CURRENTTIME -u`

# Setting time to be a block representing one day
BLOCKSINDAY=1

if [ "$MODE" == "dev" ]; then
  # Start time now
  STARTTIME=`echo "$CURRENTTIME" | bc`
else
  # Start time 1m 10s in the future
  STARTTIME=`echo "$CURRENTTIME+60*3+15" | bc`
fi
STARTTIME_S=`date -r $STARTTIME -u`
ENDTIME=`echo "$CURRENTTIME+60*4+15" | bc`
ENDTIME_S=`date -r $ENDTIME -u`

printf "MODE                 = '$MODE'\n" | tee $TEST1OUTPUT
printf "GETHATTACHPOINT      = '$GETHATTACHPOINT'\n" | tee -a $TEST1OUTPUT
printf "PASSWORD             = '$PASSWORD'\n" | tee -a $TEST1OUTPUT

printf "CONTRACTSDIR         = '$CONTRACTSDIR'\n" | tee -a $TEST1OUTPUT

printf "TOKENSOL             = '$TOKENSOL'\n" | tee -a $TEST1OUTPUT
printf "TOKENJS              = '$TOKENJS'\n" | tee -a $TEST1OUTPUT

printf "SALESOL              = '$SALESOL'\n" | tee -a $TEST1OUTPUT
printf "SALEJS               = '$SALEJS'\n" | tee -a $TEST1OUTPUT

printf "DEPLOYMENTDATA       = '$DEPLOYMENTDATA'\n" | tee -a $TEST1OUTPUT
printf "INCLUDEJS            = '$INCLUDEJS'\n" | tee -a $TEST1OUTPUT
printf "TEST1OUTPUT          = '$TEST1OUTPUT'\n" | tee -a $TEST1OUTPUT
printf "TEST1RESULTS         = '$TEST1RESULTS'\n" | tee -a $TEST1OUTPUT
printf "CURRENTTIME          = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST1OUTPUT
printf "STARTTIME            = '$STARTTIME' '$STARTTIME_S'\n" | tee -a $TEST1OUTPUT
printf "ENDTIME              = '$ENDTIME' '$ENDTIME_S'\n" | tee -a $TEST1OUTPUT

# Make copy of SOL file and modify start and end times ---
`cp $CONTRACTSDIR/*.sol .`

# --- Modify parameters ---
#`perl -pi -e "s/timePassed \> months\(3\)/timePassed \> 0/" $DTHSOL`
#`perl -pi -e "s/deadline \=  1499436000;.*$/deadline = $ENDTIME; \/\/ $ENDTIME_S/" $FUNFAIRSALETEMPSOL`
#`perl -pi -e "s/\/\/\/ \@return total amount of tokens.*$/function overloadedTotalSupply() constant returns (uint256) \{ return totalSupply; \}/" $DAOCASINOICOTEMPSOL`
#`perl -pi -e "s/BLOCKS_IN_DAY \= 5256;*$/BLOCKS_IN_DAY \= $BLOCKSINDAY;/" $DAOCASINOICOTEMPSOL`

#DIFFS1=`diff $CONTRACTSDIR/$DTHSOL $DTHSOL`
#echo "--- Differences $CONTRACTSDIR/$DTHSOL $DTHSOL ---" | tee -a $TEST1OUTPUT
#echo "$DIFFS1" | tee -a $TEST1OUTPUT

solc_0.4.17 --version | tee -a $TEST1OUTPUT

echo "var tokenOutput=`solc_0.4.17 --optimize --combined-json abi,bin,interface $TOKENSOL`;" > $TOKENJS

echo "var saleOutput=`solc_0.4.17 --optimize --combined-json abi,bin,interface $SALESOL`;" > $SALEJS


geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST1OUTPUT
loadScript("$TOKENJS");
loadScript("$SALEJS");
loadScript("functions.js");

var tokenAbi = JSON.parse(tokenOutput.contracts["$TOKENSOL:BluzelleToken"].abi);
var tokenBin = "0x" + tokenOutput.contracts["$TOKENSOL:BluzelleToken"].bin;

var saleAbi = JSON.parse(saleOutput.contracts["$SALESOL:BluzelleTokenSale"].abi);
var saleBin = "0x" + saleOutput.contracts["$SALESOL:BluzelleTokenSale"].bin;

// console.log("DATA: tokenAbi=" + JSON.stringify(tokenAbi));
// console.log("DATA: tokenBin=" + tokenBin);
// console.log("DATA: saleAbi=" + JSON.stringify(saleAbi));
// console.log("DATA: saleBin=" + saleBin);

unlockAccounts("$PASSWORD");
printBalances();
console.log("RESULT: ");

// -----------------------------------------------------------------------------
var tokenMessage = "Deploy Token Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: " + tokenMessage);
var tokenContract = web3.eth.contract(tokenAbi);
var tokenTx = null;
var tokenAddress = null;
var token = tokenContract.new({from: contractOwnerAccount, data: tokenBin, gas: 4000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        tokenTx = contract.transactionHash;
      } else {
        tokenAddress = contract.address;
        addAccount(tokenAddress, "BluzelleToken");
        addTokenContractAddressAndAbi(tokenAddress, tokenAbi);
        printTxData("tokenAddress=" + tokenAddress, tokenTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(tokenTx, tokenMessage);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var saleMessage = "Deploy Sale Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: " + saleMessage);
var saleContract = web3.eth.contract(saleAbi);
var saleTx = null;
var saleAddress = null;
var sale = saleContract.new(multisig, {from: contractOwnerAccount, data: saleBin, gas: 4000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        saleTx = contract.transactionHash;
      } else {
        saleAddress = contract.address;
        addAccount(saleAddress, "BluzelleTokenSale");
        addSaleContractAddressAndAbi(saleAddress, saleAbi);
        printTxData("saleAddress=" + saleAddress, saleTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(saleTx, saleMessage);
printSaleContractDetails();
console.log("RESULT: ");


exit;

// -----------------------------------------------------------------------------
var aptMessage = "Deploy APT";
// -----------------------------------------------------------------------------
console.log("RESULT: " + aptMessage);
var aptContract = web3.eth.contract(aptAbi);
var aptTx = null;
var aptAddress = null;
var apt = aptContract.new(mmtfAddress, {from: contractOwnerAccount, data: aptBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        aptTx = contract.transactionHash;
      } else {
        aptAddress = contract.address;
        addAccount(aptAddress, "APT");
        addTokenContractAddressAndAbi(aptAddress, aptAbi);
        printTxData("aptAddress=" + aptAddress, aptTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(aptTx, aptMessage);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var aptMintMessage = "Mint APT Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + aptMintMessage);
var aptMint_1Tx = apt.generateTokens(account3, "1000000000000000000000", {from: contractOwnerAccount, gas: 2000000});
var aptMint_2Tx = apt.generateTokens(account4, "2000000000000000000000", {from: contractOwnerAccount, gas: 2000000});
while (txpool.status.pending > 0) {
}
printTxData("aptMint_1Tx", aptMint_1Tx);
printTxData("aptMint_2Tx", aptMint_2Tx);
printBalances();
failIfTxStatusError(aptMint_1Tx, aptMintMessage + " - ac3 1,000 APT");
failIfTxStatusError(aptMint_2Tx, aptMintMessage + " - ac4 2,000 APT");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var aixMessage = "Deploy AIX";
// -----------------------------------------------------------------------------
console.log("RESULT: " + aixMessage);
var aixContract = web3.eth.contract(aixAbi);
var aixTx = null;
var aixAddress = null;
var aix = aixContract.new(mmtfAddress, {from: contractOwnerAccount, data: aixBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        aixTx = contract.transactionHash;
      } else {
        aixAddress = contract.address;
        addAccount(aixAddress, "AIX");
        addTokenContractAddressAndAbi(aixAddress, aixAbi);
        printTxData("aixAddress=" + aixAddress, aixTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(aixTx, aixMessage);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var contribMessage = "Deploy Contribution";
// -----------------------------------------------------------------------------
console.log("RESULT: " + contribMessage);
var contribContract = web3.eth.contract(contribAbi);
var contribTx = null;
var contribAddress = null;
var contrib = contribContract.new(aixAddress, {from: contractOwnerAccount, data: contribBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        contribTx = contract.transactionHash;
      } else {
        contribAddress = contract.address;
        addAccount(contribAddress, "Contribution");
        addCrowdsaleContractAddressAndAbi(contribAddress, contribAbi);
        printTxData("contribAddress=" + contribAddress, contribTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(contribTx, contribMessage);
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var aixChangeControllerMessage = "AIX changeController(Contribution)";
// -----------------------------------------------------------------------------
console.log("RESULT: " + aixChangeControllerMessage);
var aixChangeControllerTx = aix.changeController(contribAddress, {from: contractOwnerAccount, gas: 2000000});
while (txpool.status.pending > 0) {
}
printTxData("aixChangeControllerTx", aixChangeControllerTx);
printBalances();
failIfTxStatusError(aixChangeControllerTx, aixChangeControllerMessage);
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployTokenHoldersMessage = "Deploy Token Holders & Exchanger";
var controller = contractOwnerAccount;
// -----------------------------------------------------------------------------
console.log("RESULT: " + deployTokenHoldersMessage);
var cthContract = web3.eth.contract(cthAbi);
var cthTx = null;
var cthAddress = null;
var cth = cthContract.new(controller, contribAddress, aixAddress, {from: contractOwnerAccount, data: cthBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        cthTx = contract.transactionHash;
      } else {
        cthAddress = contract.address;
        addAccount(cthAddress, "CommunityTokenHolder");
        // addPlaceHolderContractAddressAndAbi(cthAddress, cthAbi);
        printTxData("cthAddress=" + cthAddress, cthTx);
      }
    }
  }
);
var dthContract = web3.eth.contract(dthAbi);
var dthTx = null;
var dthAddress = null;
var dth = dthContract.new(controller, contribAddress, aixAddress, {from: contractOwnerAccount, data: dthBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        dthTx = contract.transactionHash;
      } else {
        dthAddress = contract.address;
        addAccount(dthAddress, "DevTokensHolder");
        // addPlaceHolderContractAddressAndAbi(dthAddress, dthAbi);
        printTxData("dthAddress=" + dthAddress, dthTx);
      }
    }
  }
);
var rthContract = web3.eth.contract(rthAbi);
var rthTx = null;
var rthAddress = null;
var rth = rthContract.new(controller, contribAddress, aixAddress, {from: contractOwnerAccount, data: rthBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        rthTx = contract.transactionHash;
      } else {
        rthAddress = contract.address;
        addAccount(rthAddress, "RemainderTokenHolder");
        // addPlaceHolderContractAddressAndAbi(rthAddress, rthAbi);
        printTxData("rthAddress=" + rthAddress, rthTx);
      }
    }
  }
);
var exchangerContract = web3.eth.contract(exchangerAbi);
var exchangerTx = null;
var exchangerAddress = null;
var exchanger = exchangerContract.new(aptAddress, aixAddress, contribAddress, {from: contractOwnerAccount, data: exchangerBin, gas: 4000000},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        exchangerTx = contract.transactionHash;
      } else {
        exchangerAddress = contract.address;
        addAccount(exchangerAddress, "Exchanger");
        // addPlaceHolderContractAddressAndAbi(exchangerAddress, exchangerAbi);
        printTxData("exchangerAddress=" + exchangerAddress, exchangerTx);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(cthTx, deployTokenHoldersMessage + " - CommunityTokenHolder");
failIfTxStatusError(dthTx, deployTokenHoldersMessage + " - DevTokensHolder");
failIfTxStatusError(rthTx, deployTokenHoldersMessage + " - RemainderTokenHolder");
failIfTxStatusError(exchangerTx, deployTokenHoldersMessage + " - Exchanger");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var initialiseContributionMessage = "Initialise Contribution";
var collectorWeiCap = web3.toWei("1000", "ether");
var totalWeiCap = web3.toWei("10000", "ether");
var startTime = $STARTTIME;
var endTime = $ENDTIME;
// -----------------------------------------------------------------------------
console.log("RESULT: " + initialiseContributionMessage);
var initialiseContributionTx = contrib.initialize(aptAddress, exchangerAddress, multisig, rthAddress, dthAddress, cthAddress, collector, 
  collectorWeiCap, totalWeiCap, startTime, endTime, {from: contractOwnerAccount, gas: 2000000});
while (txpool.status.pending > 0) {
}
printTxData("initialiseContributionTx", initialiseContributionTx);
printBalances();
failIfTxStatusError(initialiseContributionTx, initialiseContributionMessage + " - 3,000 APT = 3,000 ETH = 7,500,000 AIX");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


waitUntil("startTime", startTime, 0);


// -----------------------------------------------------------------------------
var exchangePresaleMessage = "Exchange Presale APT to AIX; Whitelist";
// -----------------------------------------------------------------------------
console.log("RESULT: " + exchangePresaleMessage);
var exchangePresale_1Tx = exchanger.collect({from: account3, gas: 2000000});
var exchangePresale_2Tx = exchanger.collect({from: account4, gas: 2000000});
var whitelist_1Tx = contrib.whitelist(account3, {from: contractOwnerAccount, gas: 2000000});
var whitelist_2Tx = contrib.whitelist(account4, {from: contractOwnerAccount, gas: 2000000});
var whitelist_3Tx = contrib.whitelist(account5, {from: contractOwnerAccount, gas: 2000000});
while (txpool.status.pending > 0) {
}
printTxData("exchangePresale_1Tx", exchangePresale_1Tx);
printTxData("exchangePresale_2Tx", exchangePresale_2Tx);
printTxData("whitelist_1Tx", whitelist_1Tx);
printTxData("whitelist_2Tx", whitelist_2Tx);
printTxData("whitelist_3Tx", whitelist_3Tx);
printBalances();
failIfTxStatusError(exchangePresale_1Tx, exchangePresaleMessage + " - account3 1,000 APT -> 2,500,000 AIX");
failIfTxStatusError(exchangePresale_2Tx, exchangePresaleMessage + " - account4 2,000 APT -> 5,000,000 AIX");
failIfTxStatusError(whitelist_1Tx, exchangePresaleMessage + " - whitelist(account3)");
failIfTxStatusError(whitelist_2Tx, exchangePresaleMessage + " - whitelist(account4)");
failIfTxStatusError(whitelist_3Tx, exchangePresaleMessage + " - whitelist(account5)");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account3, to: contribAddress, gas: 400000, value: web3.toWei("1000", "ether")});
var sendContribution1_2Tx = eth.sendTransaction({from: account4, to: contribAddress, gas: 400000, value: web3.toWei("2000", "ether")});
var sendContribution1_3Tx = eth.sendTransaction({from: account5, to: contribAddress, gas: 400000, value: web3.toWei("3000", "ether")});
var sendContribution1_4Tx = eth.sendTransaction({from: account6, to: contribAddress, gas: 400000, value: web3.toWei("3000", "ether")});
while (txpool.status.pending > 0) {
}
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printTxData("sendContribution1_3Tx", sendContribution1_3Tx);
printTxData("sendContribution1_4Tx", sendContribution1_4Tx);
printBalances();
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " ac3 1000 ETH -> 2,300,000 AIX");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " ac4 2000 ETH -> 4,600,000 AIX");
failIfTxStatusError(sendContribution1_3Tx, sendContribution1Message + " ac5 3000 ETH -> 6,900,000 AIX");
passIfTxStatusError(sendContribution1_4Tx, sendContribution1Message + " ac6 1000 ETH - Expecting Failure");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var finaliseMessage = "Finalise Crowdsale";
// -----------------------------------------------------------------------------
console.log("RESULT: " + finaliseMessage);
var finalise_1Tx = contrib.finalize({from: contractOwnerAccount, gas: 2000000});
var finalise_2Tx = contrib.allowTransfers(true, {from: contractOwnerAccount, gas: 2000000});
while (txpool.status.pending > 0) {
}
printTxData("finalise_1Tx", finalise_1Tx);
printTxData("finalise_2Tx", finalise_2Tx);
printBalances();
failIfTxStatusError(finalise_1Tx, finaliseMessage + " - [removed Remainder 8,000,000;] Dev 11,490,196.078431372549019607; Community 16,660,784.313725490196078431");
failIfTxStatusError(finalise_2Tx, finaliseMessage + " - contrib.allowTransfers(true)");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var transfersMessage = "Move Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + transfersMessage);
var transfers1Tx = aix.transfer(account6, "1000000000000", {from: account3, gas: 100000});
var transfers2Tx = aix.approve(account7,  "30000000000000000", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
var transfers3Tx = aix.transferFrom(account4, account8, "30000000000000000", {from: account7, gas: 200000});
while (txpool.status.pending > 0) {
}
printTxData("transfers1Tx", transfers1Tx);
printTxData("transfers2Tx", transfers2Tx);
printTxData("transfers3Tx", transfers3Tx);
printBalances();
failIfTxStatusError(transfers1Tx, transfersMessage + " - transfer 0.000001 tokens ac4 -> ac6. CHECK for movement");
failIfTxStatusError(transfers2Tx, transfersMessage + " - approve 0.03 tokens ac5 -> ac7");
failIfTxStatusError(transfers3Tx, transfersMessage + " - transferFrom 0.03 tokens ac5 -> ac7. CHECK for movement");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var collectTokensMessage = "Collect Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + collectTokensMessage);
var collectTokens1Tx = cth.collectTokens({from: contractOwnerAccount, gas: 1000000});
var collectTokens2Tx = dth.collectTokens({from: contractOwnerAccount, gas: 1000000});
while (txpool.status.pending > 0) {
}
printTxData("collectTokens1Tx", collectTokens1Tx);
printTxData("collectTokens2Tx", collectTokens2Tx);
printBalances();
failIfTxStatusError(collectTokens1Tx, collectTokensMessage + " - CommunityTokenHolder.collectTokens() = 12,111,764.705882352941176470 x 10/29 = 4,176,470.588235294117647");
failIfTxStatusError(collectTokens2Tx, collectTokensMessage + " - DevTokensHolder.collectTokens() = 8,352,941.176470588235294117 x .25 = 2,088,235.294117647058824");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


EOF
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
