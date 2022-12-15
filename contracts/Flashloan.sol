// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {FlashLoanReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanReceiverBase.sol";
import {IFlashLoanReceiver} from "@aave/core-v3/contracts/flashloan/interfaces/IFlashLoanReceiver.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import "./ITrade.sol";


 abstract contract FlashLoan is FlashLoanReceiverBase {
    address payable owner;
    address private TradeContractAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
    //address private FlashloanContractAddress = ; // !!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        ITrade tradeContract = ITrade(TradeContractAddress);
        //Flasharb flasharb = Flasharb(FlasharbContractAddress);

        address router1;
        address baseAsset;
        address token1 ;
        address token2 ;
        uint256 tradeamount ;

    constructor(address _addressProvider)
        FlashLoanReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        owner = payable(msg.sender);
        
    } 

    function gettradedata(address _router1, address _baseAsset, address _token1, address _token2, uint256 _amount) public {
         router1 = _router1;
         baseAsset = _baseAsset;
         token1 = _token1; 
         token2 = _token2;
         tradeamount =  _amount;
        
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        //
        // This contract now has the funds requested.
        // Your logic goes here.
         tradeContract.instaTrade(router1, baseAsset,token1 ,token2, tradeamount);
        //{gasPrice: ethers.utils.parseUnits('200', 'gwei'),gasLimit: 1000000}
        // Arbirtage operation ethers.utils.parseUnits('200', 'gwei')

        // Approve the Pool contract allowance to *pull* the owed amount
        uint256 amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);

        return true;
    }

    function requestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }
    receive() external payable {}

    




}