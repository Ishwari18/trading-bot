// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {FlashLoanReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanReceiverBase.sol";
import {IFlashLoanReceiver} from "@aave/core-v3/contracts/flashloan/interfaces/IFlashLoanReceiver.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "./ITrade.sol";
import "./IFlashloan.sol";

contract  Flasharb is IFlashloan {
    address payable owner;
    address private TradeContractAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
    //address private FlashloanContractAddress = ; // !!!!!!!!!!!!!!!!!!!!!!!!!!!

    ITrade tradeContract = ITrade(TradeContractAddress);
    IFlashloan flashloan = IFlashloan(FlashloanContractAddress);
        address router1;
        address baseAsset;
        address token1 ;
        address token2 ;
        uint256 tradeamount ;
        uint256 tradesize;

    constructor(address _addressProvider)
        FlashLoanReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        owner = payable(msg.sender);
        
    }

    // function gettradedata(address _router1, address _baseAsset, address _token1, address _token2, uint256 _amount) public returns (address,address,address, address, uint256) {
    //      router1 = _router1;
    //      baseAsset = _baseAsset;
    //      token1 = _token1;
    //      token2 = _token2;
    //      tradeamount = _amount;
    //      return(router1,baseAsset,token1, token2, tradeamount);
    // }

    function requestFlashLoan(address _baseAsset, uint256 _tradeSize) public {
        flashloan.requestFlashLoan(baseAsset,tradeSize);
    }

}