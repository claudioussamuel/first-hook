// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import {PointsHook} from "../src/PointsHook.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {HookMiner} from "v4-periphery/src/utils/HookMiner.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployHook is Script {
    function run() external {
        // Create HelperConfig to get PoolManager
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        address poolManager = config.poolManager;

        // Hook flags
        uint160 flags = uint160(Hooks.AFTER_SWAP_FLAG);

        // Mine a salt that will produce a hook address with the correct flags
        bytes memory constructorArgs = abi.encode(poolManager);
        
        // Use CREATE2Deployer proxy address for `forge script`
        address CREATE2_DEPLOYER = 0x4e59b44847b379578588920cA78FbF26c0B4956C;
        (address hookAddress, bytes32 salt) = HookMiner.find(
            CREATE2_DEPLOYER,
            flags,
            type(PointsHook).creationCode,
            constructorArgs
        );

        console2.log("Mining completed. Hook address:", hookAddress);

        vm.startBroadcast();
        PointsHook hook = new PointsHook{salt: salt}(IPoolManager(poolManager));
        require(address(hook) == hookAddress, "Hook address mismatch!");
        vm.stopBroadcast();
    }
}
