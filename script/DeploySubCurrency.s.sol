// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {SubCurrency} from "../src/SubCurrency.sol";

contract DeploySubCurrency is Script {
    function run() external returns (SubCurrency) {
        vm.startBroadcast();

        SubCurrency subCurrency = new SubCurrency();

        vm.stopBroadcast();
        return subCurrency;
    }
}
