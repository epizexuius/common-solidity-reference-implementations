//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SBitmap {
    /**
    All the flags are stored in a single bitmap and can be accessed with bitwise operations.This can be a uint256
    if outside of a struct, inside a struct maybe if it is helpful in struct packing uint8 can be used to pack it efficiently
    otherwise uint256 should be more gas optimized because uint8 will require conversions.

    This method of storing flags can maybe be further optimized by having a single array of bytes32 and
    having member address and flags together-: first 20 bytes address and last 2 bytes for the flag.The handling will be
    a little complicated but lots of potential for optimization.    
    */
    struct MemberData {
        uint8 flagBitMap;
    }

    //To keep track of all flags for members
    mapping(address => MemberData) memberToMemberData;

    //Let the discount flag be in the first bit of the bitmap, the reward flag in 2nd bit, the zeroFee flag in
    //3rd and so on
    function _setBitMapIndex(uint8 bitmapIndex, address _member) internal {
        uint8 bitmap = memberToMemberData[_member].flagBitMap;
        bitmap = bitmap | uint8(1 << bitmapIndex);
        memberToMemberData[_member].flagBitMap = bitmap;
    }

    //public only for testing purpose can be be set to internal or private
    function checkBitmapIndex(uint8 bitmapIndex, address _member)
        public
        view
        returns (bool)
    {
        require(bitmapIndex < 8, "Exceeding bitmap range");
        uint8 bitAtIndex = (memberToMemberData[_member].flagBitMap &
            uint8(1 << bitmapIndex));
        return bitAtIndex > 0;
    }

    //test function to set any flag
    function fulfillDiscount(uint8 flagIndex) external {
        require(flagIndex < 8, "Exceeding bitmap range");
        _setBitMapIndex(flagIndex, msg.sender);
    }
}
