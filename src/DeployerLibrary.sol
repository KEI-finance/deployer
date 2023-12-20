// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

import "./constants.sol";

library DeployerLibrary {

    function deployAddress(bytes memory bytecode, uint256 salt) public view returns (address addr) {
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), CREATE2_DEPLOYER_ADDRESS, salt, keccak256(bytecode))
        );
        return address(uint160(uint256(hash)));
    }

    function deploy(bytes memory bytecode, uint256 salt) public returns (address addr) {

        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }

        emit Deployed(addr);

        call(calls);
    }

    function clone(address target, uint256 salt, FunctionCall[] calldata calls) public returns (address addr) {
        return Clones.cloneDeterministic(target, bytes32(salt));
    }

    function call(FunctionCall[] calldata calls) public returns (bytes[] memory results) {
        results = new bytes[](calls.length);
        for (uint i = 0; i < calls.length; i++) {
            results[i] = calls[i].target.functionCall(calls[i].data);
            emit Call(calls[i].target, calls[i].data, results[i]);
        }
    }
}
