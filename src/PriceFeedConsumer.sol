// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title The PriceConsumerV3 contract
 * @notice Acontract that returns latest price from Chainlink Price Feeds
 */
contract PriceFeedConsumer {
    AggregatorV3Interface internal priceFeedBTC;
    AggregatorV3Interface internal priceFeedUSD;
    AggregatorV3Interface internal priceFeedETH;
    AggregatorV3Interface internal priceFeedUSDTUsd;

    constructor() {
        priceFeedBTC = AggregatorV3Interface(
            0xc907E116054Ad103354f2D350FD2514433D57F6f
        );

        priceFeedUSD = AggregatorV3Interface(
            0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
        );

        priceFeedETH = AggregatorV3Interface(
            0x327e23A4855b6F663a28c5161541d69Af8973302
        );

        priceFeedUSDTUsd = AggregatorV3Interface(
            0x0A6513e40db6EB1b165753AD52E80663aeA50545
        );
    }

    /**
     * @notice Returns the latest price
     *
     * @return latest price
     */

    function getLatestPriceUSD() external view returns (int256) {
        (, int256 price, , , ) = priceFeedUSD.latestRoundData();
        return price;
    }

    function getLatestPriceETH() external view returns (int256) {
        (, int256 price, , , ) = priceFeedETH.latestRoundData();
        return price;
    }

    function getLatestPriceBTC() external view returns (int256) {
        (, int256 price, , , ) = priceFeedBTC.latestRoundData();
        return price;
    }

    function getLastestPriceUSDTUsd() external view returns (int256) {
        (, int256 price, , , ) = priceFeedUSDTUsd.latestRoundData();
        return price;
    }

    function getPriceFeedBTC() external view returns (AggregatorV3Interface) {
        return priceFeedBTC;
    }
}
