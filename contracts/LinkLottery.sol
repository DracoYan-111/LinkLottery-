//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract RandomNumberConsumer is VRFConsumerBase, Ownable {
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256[8] internal requestRandom;
    bytes32 internal request;

    /**
     * 继承VRFConsumerBase
     * VRF地址 0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9
     * LINK地址 0xa36085F69e2889c224210F603D836748e7dC0088
     * KeyHash 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4
     * _x x人领取
     * _y y输出量
     */
    constructor(
    )
    VRFConsumerBase(
        0xdD3782915140c8f3b190B5D67eAc6dc5760C46E9, // VRF Coordinator
        0xa36085F69e2889c224210F603D836748e7dC0088  // LINK Token
    )
    {
        keyHash = 0x6c3699283bda56ad74f6b855546325b68d482e983852a7a82979cc4807b641f4;
        fee = 0.1 * 10 ** 18;

    }

    /**
     * @dev 生成随机数
     * @return requestId 用于验证的id
     */
    function getRandomNumber() external onlyOwner returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");
        return requestRandomness(keyHash, fee);
    }

    /**
     * @dev 回调方法,获得1-50之间的随机数
     * @param requestId 用于验证的id
     * @param randomness 得到的随机数
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        request = requestId;
        requestRandom = expand(randomness);
    }

    /**
    * @dev 得到n个随机数
    * @param randomness 得到随机数的数量
    * @return expandedValues n个随机数的数组
    */
    function expand(uint256 randomness) private pure returns (uint256[8] memory expandedValues) {
        for (uint256 i = 0; i < expandedValues.length; i++) {
            expandedValues[i] = (uint256(keccak256(abi.encode(randomness, i))) % 99) + 1;
        }
        return expandedValues;
    }

    /**
    * @dev 返回中奖的随机数
    * @return requestRandom 最后开奖的随机数组
    */
    function getRequestRandom() external view returns (uint256[8] memory){
        return requestRandom;
    }
}

/// @title 购彩方法
contract buyLottery is Ownable {
}
