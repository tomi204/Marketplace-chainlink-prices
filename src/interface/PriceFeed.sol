// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface PriceFeedConsumer {
    function getLatestPriceUSD() external view returns (int256);

    function getLatestPriceETH() external view returns (int256);

    function getLatestPriceBTC() external view returns (int256);

    function getLastestPriceMaticUsd() external view returns (int256);
}
