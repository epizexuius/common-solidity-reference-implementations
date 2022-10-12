//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MerkleProof.sol";
import "./interfaces/IERC20.sol";

contract MerkleDistributor {
    address public immutable token;
    bytes32 public immutable merkleRoot;

    mapping(address => bool) public isClaimed;

    constructor(address token_, bytes32 merkleRoot_) {
        token = token_;
        merkleRoot = merkleRoot_;
    }

    function claim(address account, bytes32[] calldata merkleProof) external {
        require(!isClaimed[account], "Already claimed.");
        uint256 rewardAmount = 2;

        /**@notice Checking merkle proof only for merkle tree created with hashes of account addresses
        // because the reward token amount is constant. For variable reward token amount have to
        // have account address and reward amount in leaf hash while merkle tree construction and here
        // in node checking*/

        // bytes32 node = keccak256(abi.encodePacked(account, amount));
        bytes32 node = keccak256(abi.encodePacked(account));
        bool isValidProof = MerkleProof.verifyCalldata(
            merkleProof,
            merkleRoot,
            node
        );
        require(isValidProof, "Invalid proof.");

        isClaimed[account] = true;
        //Reward token amount for each claimant is constant = 2
        require(
            IERC20(token).transfer(account, rewardAmount),
            "Transfer failed."
        );
    }
}
