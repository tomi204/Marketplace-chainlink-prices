// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title The PriceConsumerV3 contract
 * @notice Acontract that returns latest price from Chainlink Price Feeds
 */
contract PriceFeedConsumer {
    AggregatorV3Interface internal priceFeedBTC;
    AggregatorV3Interface internal priceFeedMatic;
    AggregatorV3Interface internal priceFeedETH;
    AggregatorV3Interface internal priceFeedUSDTUsd;

    //// all tokens are on matic mainnet and the price feed is on USD
    constructor() {
        priceFeedBTC = AggregatorV3Interface(
            0xc907E116054Ad103354f2D350FD2514433D57F6f
        );

        priceFeedMatic = AggregatorV3Interface(
            0xAB594600376Ec9fD91F8e885dADF0CE036862dE0
        );

        priceFeedETH = AggregatorV3Interface(
            0xf9d5AAC6E5572AEFa6bd64108ff86a222F69B64d
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

    function getLatestPriceMATIC() external view returns (uint256) {
        (, int256 price, , , ) = priceFeedMatic.latestRoundData();
        uint256 priceToUint = uint256(price);
        return priceToUint;
    }

    function getLatestPriceETH() external view returns (uint256) {
        (, int256 price, , , ) = priceFeedETH.latestRoundData();
        uint256 priceToUint = uint256(price);
        return priceToUint;
    }

    function getLatestPriceBTC() external view returns (uint256) {
        (, int256 price, , , ) = priceFeedBTC.latestRoundData();
        uint256 priceToUint = uint256(price);
        return priceToUint;
    }

    function getLastestPriceUSDTUsd() external view returns (uint256) {
        (, int256 price, , , ) = priceFeedUSDTUsd.latestRoundData();
        uint256 priceToUint = uint256(price);
        return priceToUint;
    }
}
