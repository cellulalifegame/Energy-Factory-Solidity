// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {toWadUnsafe, toDaysWadUnsafe, wadLn} from "solmate/utils/SignedWadMath.sol";

import "../src/lib/VRGDA.sol";

contract CounterTest is Test {
    function setUp() public {}

    function testTimeLinear() public pure {
        uint256 sold = 100;
        uint256 perTimeUnit = 2;

        int256 targetSaleTime = VRGDA.getTargetSaleTimeLinear(
            toWadUnsafe(sold + 1), // next price
            toWadUnsafe(perTimeUnit)
        );

        uint256 timeSinceStart = 40 * 86400;
        int256 targetPrice = 0.2e18;
        int256 priceDecayPercent = 0.3e18;
        int256 decayConstant = wadLn(1e18 - priceDecayPercent);

        console2.logInt(targetSaleTime);
        console2.log(toDaysWadUnsafe(timeSinceStart));

        uint256 price = VRGDA.getVRGDAPrice(
            toDaysWadUnsafe(timeSinceStart),
            targetPrice,
            decayConstant,
            targetSaleTime
        );

        console2.logUint(price);
    }

    function testTimeLogistic() public pure {
        uint256 sold = 100; // already sold 100
        int256 logisticLimit = 1000e18; // max saleable  1000
        int256 timeScale = 0.02e18; // 1 / 50 = 0.02, expect 46% of total sold in 50 days

        int256 targetSaleTime = VRGDA.getTargetSaleTimeLogistic(
            toWadUnsafe(sold + 1), // next price
            logisticLimit,
            timeScale
        );

        console2.logInt(targetSaleTime);

        uint256 timeSinceStart = 20 * 86400;
        int256 targetPrice = 0.2e18;
        int256 priceDecayPercent = 0.3e18;
        int256 decayConstant = wadLn(1e18 - priceDecayPercent);

        uint256 price = VRGDA.getVRGDAPrice(
            toDaysWadUnsafe(timeSinceStart),
            targetPrice,
            decayConstant,
            targetSaleTime
        );

        console2.logUint(price);
    }

    function testTimeLogisticToLinear() public pure {
        uint256 sold = 100;

        uint256 soldBySwitch = 80;
        int256 logisticLimit = 1000e18; // max saleable  1000
        int256 timeScale = 0.02e18; // 1 / 50 = 0.02, expect 46% of total sold in 50 days
        uint256 perTimeUnit = 2;

        int256 switchTime = VRGDA.getTargetSaleTimeLogistic(
            toWadUnsafe(soldBySwitch),
            logisticLimit,
            timeScale
        );

        int256 targetSaleTime = VRGDA.getTargetSaleTimeLogisticToLinear(
            toWadUnsafe(sold + 1), // next price
            toWadUnsafe(soldBySwitch),
            switchTime,
            logisticLimit,
            timeScale,
            toWadUnsafe(perTimeUnit)
        );

        console2.logInt(targetSaleTime);

        uint256 timeSinceStart = 20 * 86400;
        int256 targetPrice = 0.2e18;
        int256 priceDecayPercent = 0.3e18;
        int256 decayConstant = wadLn(1e18 - priceDecayPercent);

        uint256 price = VRGDA.getVRGDAPrice(
            toDaysWadUnsafe(timeSinceStart),
            targetPrice,
            decayConstant,
            targetSaleTime
        );

        console2.logUint(price);
    }
}
