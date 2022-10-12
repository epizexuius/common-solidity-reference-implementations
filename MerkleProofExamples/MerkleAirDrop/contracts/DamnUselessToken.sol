// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";

//Useless ERC20 token for test purposes
contract DamnUselessToken is ERC20 {
    // Decimals are set to 18 by default in `ERC20`
    constructor() ERC20("DamnUselessToken", "DUT") {
        _mint(msg.sender, type(uint256).max);
    }
}
