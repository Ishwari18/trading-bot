//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {FlashLoanReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
//import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

interface IERC20 {
  function totalSupply() external view returns (uint);
  function balanceOf(address account) external view returns (uint);
  function transfer(address recipient, uint amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint);
  function approve(address spender, uint amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}

interface IUniswapV2Router {
  function getAmountsOut(uint256 amountIn, address[] memory path) external view returns (uint256[] memory amounts);
  function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts);
}

interface IUniswapV2Pair {
  function token0() external view returns (address);
  function token1() external view returns (address);
  function swap(uint256 amount0Out,	uint256 amount1Out,	address to,	bytes calldata data) external;
}

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

contract Trade is Ownable {
    address [] public tokens;
    
  function addTokens(address[] calldata _tokens) external onlyOwner {
    for (uint i=0; i<_tokens.length; i++) {
      tokens.push(_tokens[i]);
    }
  }

  function swap(address router, address _tokenIn, address _tokenOut, uint256 _amount) private {
    IERC20(_tokenIn).approve(router, _amount);
    address[] memory path;
    path = new address[](2);
    path[0] = _tokenIn;
    path[1] = _tokenOut;
    uint deadline = block.timestamp + 300;
    IUniswapV2Router(router).swapExactTokensForTokens(_amount, 1, path, address(this), deadline);
  }

  function getAmountOutMin(address router, address _tokenIn, address _tokenOut, uint256 _amount) public view returns (uint256 ) {
    address[] memory path;
    path = new address[](2);
    path[0] = _tokenIn;
    path[1] = _tokenOut;
    uint256 result = 0;
    try IUniswapV2Router(router).getAmountsOut(_amount, path) returns (uint256[] memory amountOutMins) {
      result = amountOutMins[path.length -1];
    } catch {
    }
    return result;
  }

  function instaSearch(address _router, address _baseAsset, uint256 _amount) external view returns (uint256,address,address) {
    uint256 amtBack;
    address token1;
    address token2;
    for (uint i1=0; i1<tokens.length; i1++) {
      for (uint i2=0; i2<tokens.length; i2++) {
          amtBack = getAmountOutMin(_router, _baseAsset, tokens[i1], _amount);
          amtBack = getAmountOutMin(_router, tokens[i1], tokens[i2], amtBack);
          amtBack = getAmountOutMin(_router, tokens[i2], _baseAsset, amtBack);
          if (amtBack > _amount) {
            token1 = tokens[i1];
            token2 = tokens[i2];
            break;
          }
      }
    }
    return (amtBack,token1,token2);
  }

  function instaTrade(address _router1, address _baseAsset, address _token1, address _token2, uint256 _amount) payable external onlyOwner {
    uint startBalance = IERC20(_baseAsset).balanceOf(address(this));
    uint token1InitialBalance = IERC20(_token1).balanceOf(address(this));
    uint token2InitialBalance = IERC20(_token2).balanceOf(address(this));
    swap(_router1,_baseAsset, _token1, _amount);
    uint tradeableAmount1 = IERC20(_token1).balanceOf(address(this)) - token1InitialBalance;
    swap(_router1,_token1, _token2, tradeableAmount1);
    uint tradeableAmount2 = IERC20(_token2).balanceOf(address(this)) - token2InitialBalance;
    swap(_router1,_token2, _baseAsset, tradeableAmount2);
    require(IERC20(_token1).balanceOf(address(this)) > startBalance, "Trade Reverted, No Profit Made");
    }

    function getBalance (address _tokenContractAddress) external view  returns (uint256) {
    uint balance = IERC20(_tokenContractAddress).balanceOf(address(this));
    return balance;
  }
  
  function recoverEth() external onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
  }

  function recoverTokens(address tokenAddress) external onlyOwner {
    IERC20 token = IERC20(tokenAddress);
    token.transfer(msg.sender, token.balanceOf(address(this)));
  }

}
