// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

contract Placeholder {
    using Address for address;

    event Fallback(bytes data, uint256 value, address sender);

    mapping(bytes4 => bytes) private $responses;

    fallback() external payable returns (bytes memory response) {
        emit Fallback(msg.data, msg.value, msg.sender);
        bytes4 sig = abi.decode(msg.data, (bytes4));
        response = $responses[sig];
        delete $responses[sig];
    }

    function setResponse(bytes4 signature, bytes memory response) external {
        $responses[signature] = response;
    }

    function functionCall(address target, bytes memory data) external payable returns (bytes memory result) {
        return target.functionCallWithValue(data, msg.value);
    }
}
