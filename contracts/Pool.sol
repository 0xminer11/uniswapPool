// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./T1.sol";
import "./T2.sol";

contract Pool{

IUniswapV2Router02 public  UniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
address public uniswapV2Pair;

Alpha public alpha;
Beta public beta;


constructor() {
        // deploying two tokens
        alpha = new Alpha();
        beta = new Beta();

        // creating UniswapV2 Pair for the the two tokens
        uniswapV2Pair = IUniswapV2Factory(UniswapV2Router.factory()).createPair(
                address(alpha),
                address(beta)
            );
    }


    function getPair() public view returns(address){
    return uniswapV2Pair;
    } 

    /**
     * 
     * @param _amountA The number of Alpha Tokens
     * @param _amountB The number of Beta Tokens
     * @return amountA Alpha Tokens
     * @return amountB Beta Tokens
     * @return liquidity Liquidity of Alpha and Beta Token Pool.
     */
    function addLiquidity(
        uint _amountA,
        uint _amountB
    ) public returns(uint amountA, uint amountB, uint liquidity){
    // To add amountA and amountB to the pool first we need to transfer the ammount. and approve for the uniswapV2Router address
        alpha.transferFrom(msg.sender, address(this), _amountA);
        beta.transferFrom(msg.sender, address(this), _amountB);

        alpha.approve(address(UniswapV2Router), _amountA);
        beta.approve(address(UniswapV2Router), _amountB);

      ( amountA, amountB, liquidity) = UniswapV2Router.addLiquidity(
            address(alpha),
            address(beta),
            amountA,
            amountB,
            1,
            1,
            address(this),
            block.timestamp
        );

    }

    /**
     * 
     * @return amountA Alpha tokens
     * @return amountB , Beta Tokens
     */
    function removeLiquidity() public returns( uint amountA,uint amountB){

        // First we need to check how much balance is ther for this pool and need to Approve tokens to Router
        uint liquidity = IERC20(uniswapV2Pair).balanceOf(address(this));
        IERC20(uniswapV2Pair).approve(address(UniswapV2Router), liquidity);

        // remove Liquidity it will return how much tokens we need to return to the users
        (amountA, amountB) = UniswapV2Router.removeLiquidity(
            address(alpha),
            address(beta),
            liquidity,
            1,
            1,
            address(this),
            block.timestamp
        );
        // Transafering the tokens
        alpha.transfer(msg.sender, amountA);
        beta.transfer(msg.sender, amountB);
    }

    /**
     * 
     * @param amountIn Exact amount you want to swap
     * @param amountOutMin  minimum amount you ll get
     * @param fromToken  From tokem address
     * @param toToken   to token address
     */
    function swapForExactAmountIn(
        uint amountIn,
        uint amountOutMin,
        address fromToken,
        address toToken
    ) external returns (uint amountOut) {
        // First we need to transfer the amount to contract address and need to approve to Router contract address
        IERC20(fromToken).transferFrom(msg.sender, address(this), amountIn);
        IERC20(fromToken).approve(address(UniswapV2Router), amountIn);

        address[] memory path;
        path = new address[](2);
        path[0] = address(fromToken);
        path[1] = address(toToken);

        // swap Exact tokens for Tokens You will get amounts for how much you will get as swaped tokens as return
        uint[] memory amounts = UniswapV2Router.swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            msg.sender,
            block.timestamp
        );

        // send swapped token to the caller 
        uint toSend = IERC20(toToken).balanceOf(address(this));
        require(
            IERC20(toToken).transfer(msg.sender, toSend),
            "Transfer Failed"
        );

        return toSend;
    }

    /**
     * 
     * @param amountOutDesired Exact amount out 
     * @param amountInMax  Max amount In
     * @param fromToken  From token address
     * @param toToken  To TokenAddress
     */
    function swapForExactAmountOut(
        uint amountOutDesired,
        uint amountInMax,
        address fromToken,
        address toToken
    ) external returns (uint amountOut) {

        // First we need to transfer the amount to contract address and need to approve to Router contract address
        IERC20(fromToken).transferFrom(msg.sender, address(this), amountInMax);
        IERC20(fromToken).approve(address(UniswapV2Router), amountInMax);

        address[] memory path;
        path = new address[](2);
        path[0] = fromToken;
        path[1] = toToken;
        // swap Exact tokens for Tokens You will get amounts for how much you will get as swaped tokens as return
        uint[] memory amounts = UniswapV2Router.swapTokensForExactTokens(
            amountOutDesired,
            amountInMax,
            path,
            msg.sender,
            block.timestamp
        );

        // Refund residue calyp to msg.sender
        if (amounts[0] < amountInMax) {
            IERC20(fromToken).transfer(msg.sender, amountInMax - amounts[0]);
        }

        // send swapped token to the caller
        uint toSend = IERC20(toToken).balanceOf(address(this));
        require(
            IERC20(toToken).transfer(msg.sender, toSend),
            "Transfer Failed"
        );

        return amounts[1];
    }
}




