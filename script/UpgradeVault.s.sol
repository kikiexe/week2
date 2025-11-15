
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";
import {VaultV2} from "../src/VaultV2.sol";

contract UpgradeVault is Script {
    VaultV2 public vaultV2Impl;
    address public vaultProxyAddress = address(0xC754B39c841984Ac9e5dfE09645881f0EA2f204b);

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.createSelectFork(vm.envString("BASE_SEPOLIA_URL"));
        vm.startBroadcast(deployerPrivateKey);

        // Deploy VaultV2 implementation
        vaultV2Impl = new VaultV2();
        console.log("VaultV2 Implementation deployed at:", address(vaultV2Impl));

        // Upgrade proxy to point to the VaultV2 implementation
        VaultV2(vaultProxyAddress).upgradeToAndCall(address(vaultV2Impl), "");

        console.log("Vault Proxy upgraded to VaultV2 at:", vaultProxyAddress);
        vm.stopBroadcast();
    }
}
