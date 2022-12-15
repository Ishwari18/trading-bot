//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

interface IFlashloan {
    function gettradedata(address _router1, address _baseAsset, address _token1, address _token2, uint256 _amount) public ;

    function requestFlashLoan(address _token, uint256 _amount) public ;
}