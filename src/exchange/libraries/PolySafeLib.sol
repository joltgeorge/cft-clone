// SPDX-License-Identifier: MIT
pragma solidity <0.9.0;

/// @title PolySafeLib
/// @notice Helper library to compute Polymarket gnosis safe addresses
library PolySafeLib {
    bytes private constant proxyCreationCode =
        hex"6080604052348015600e575f80fd5b50604051610163380380610163833981016040819052602b9160b2565b6001600160a01b038116608f5760405162461bcd60e51b815260206004820152602260248201527f496e76616c69642073696e676c65746f6e20616464726573732070726f766964604482015261195960f21b606482015260840160405180910390fd5b5f80546001600160a01b0319166001600160a01b039290921691909117905560dd565b5f6020828403121560c1575f80fd5b81516001600160a01b038116811460d6575f80fd5b9392505050565b607a806100e95f395ff3fe60806040525f80546001600160a01b03169035632cf35bc960e11b01602657805f5260205ff35b365f80375f80365f845af490503d5f803e80603f573d5ffd5b503d5ff3fea26469706673582212203b883df42a3a23d3d104b2b77d42868eb5c55945b457a0d0dcb96fd3ea9d120464736f6c634300081a0033";

    /// @notice Gets the Polymarket Gnosis safe address for a signer
    /// @param signer   - Address of the signer
    /// @param deployer - Address of the deployer contract
    function getSafeAddress(address signer, address implementation, address deployer)
        internal
        pure
        returns (address safe)
    {
        bytes32 bytecodeHash = keccak256(getContractBytecode(implementation));
        bytes32 salt = keccak256(abi.encode(signer));
        safe = _computeCreate2Address(deployer, bytecodeHash, salt);
    }

    function getContractBytecode(address masterCopy) internal pure returns (bytes memory) {
        return abi.encodePacked(proxyCreationCode, abi.encode(masterCopy));
    }

    function _computeCreate2Address(address deployer, bytes32 bytecodeHash, bytes32 salt)
        internal
        pure
        returns (address)
    {
        bytes32 _data = keccak256(abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash));
        return address(uint160(uint256(_data)));
    }
}
