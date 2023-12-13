// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface PriceFeedConsumer {
    function getLatestPriceMATIC() external view returns (uint256);

    function getLatestPriceETH() external view returns (uint256);

    function getLatestPriceBTC() external view returns (uint256);

    function getLastestPriceUSDTUsd() external view returns (uint256);
}
