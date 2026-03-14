// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console2} from "forge-std/Script.sol";

abstract contract CodeConstants {
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ETH_MAINNET_CHAIN_ID = 1;
    uint256 public constant BASE_MAINNET_CHAIN_ID = 8453;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}

contract HelperConfig is CodeConstants, Script {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error HelperConfig__InvalidChainId();

    /*//////////////////////////////////////////////////////////////
                                 TYPES
    //////////////////////////////////////////////////////////////*/
    struct NetworkConfig {
        address poolManager;
    }

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    NetworkConfig public localNetworkConfig;
    mapping(uint256 chainId => NetworkConfig) public networkConfigs;

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor() {
        // Ethereum Sepolia Testnet
        networkConfigs[ETH_SEPOLIA_CHAIN_ID] = getSepoliaConfig();

        // Ethereum Mainnet
        networkConfigs[ETH_MAINNET_CHAIN_ID] = getMainnetConfig();

        // Base Mainnet
        networkConfigs[BASE_MAINNET_CHAIN_ID] = getBaseConfig();
    }

    function getConfig() public view returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    function setConfig(
        uint256 chainId,
        NetworkConfig memory networkConfig
    ) public {
        networkConfigs[chainId] = networkConfig;
    }

    function getConfigByChainId(
        uint256 chainId
    ) public view returns (NetworkConfig memory) {
        if (networkConfigs[chainId].poolManager != address(0)) {
            return networkConfigs[chainId];
        } else if (chainId == LOCAL_CHAIN_ID) {
            // Revert or mock locally depending on implementation setup,
            // Returning address(0) for local config since we deploy mock poolmanager in test
            return localNetworkConfig;
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getMainnetConfig()
        public
        pure
        returns (NetworkConfig memory mainnetNetworkConfig)
    {
        mainnetNetworkConfig = NetworkConfig({
            poolManager: 0x0000000000000000000000000000000000000000 // Replace with actual Mainnet PoolManager
        });
    }

    function getSepoliaConfig()
        public
        pure
        returns (NetworkConfig memory sepoliaNetworkConfig)
    {
        sepoliaNetworkConfig = NetworkConfig({
            poolManager: 0x0000000000000000000000000000000000000000 // Replace with actual Sepolia PoolManager
        });
    }

    function getBaseConfig()
        public
        pure
        returns (NetworkConfig memory baseNetworkConfig)
    {
        baseNetworkConfig = NetworkConfig({
            poolManager: 0x0000000000000000000000000000000000000000 // Replace with actual Base PoolManager
        });
    }
}
