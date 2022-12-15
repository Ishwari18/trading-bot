//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

interface ITrade {
    function addTokens(address[] calldata _tokens) external ;

    function swap(address router, address _tokenIn, address _tokenOut, uint256 _amount) external;

    function getAmountOutMin(address router, address _tokenIn, address _tokenOut, uint256 _amount)  external view returns (uint256 );

    function instaSearch(address _router, address _baseAsset, uint256 _amount) external view returns (uint256,address,address);

    function instaTrade(address _router1, address _baseAsset, address _token1, address _token2, uint256 _amount) payable external  ;


    function getBalance (address _tokenContractAddress) external view  returns (uint256);

    function recoverEth() external ;

    function recoverTokens(address tokenAddress) external  ;

}