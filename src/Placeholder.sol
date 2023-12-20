// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

contract Placeholder {
    using Address for address;

    function functionCall(address target, bytes memory data) external payable returns (bytes memory result) {
        return target.functionCallWithValue(data, msg.value);
    }
}
