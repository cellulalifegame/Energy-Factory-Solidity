// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

library BitMaps {
    struct BitMap {
        mapping(uint256 => uint256) _data;
    }

    /**
     * @dev Returns whether the bit at `index` is set.
     */
    function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
        uint256 bucket = index >> 8;
        uint256 mask = 1 << (index & 0xff);
        return bitmap._data[bucket] & mask != 0;
    }

    /**
     * @dev Sets the bit at `index` to the boolean `value`.
     */
    function setTo(BitMap storage bitmap, uint256 index, bool value) internal {
        if (value) {
            set(bitmap, index);
        } else {
            unset(bitmap, index);
        }
    }

    /**
     * @dev Sets the bit at `index`.
     */
    function set(BitMap storage bitmap, uint256 index) internal {
        uint256 bucket = index >> 8;
        uint256 mask = 1 << (index & 0xff);
        bitmap._data[bucket] |= mask;
    }

    /**
     * @dev Unsets the bit at `index`.
     */
    function unset(BitMap storage bitmap, uint256 index) internal {
        uint256 bucket = index >> 8;
        uint256 mask = 1 << (index & 0xff);
        bitmap._data[bucket] &= ~mask;
    }

    function getBucket(BitMap storage bitmap, uint256 index)
        internal
        view
        returns (uint256)
    {
        return bitmap._data[index];
    }


    /**
    * @dev Sets a `bucket` in the bitmap under the `mask`.
     */
    function setBucket(BitMap storage bitmap, uint256 bucket, uint256 mask) internal {
        bitmap._data[bucket] |= mask;
    }

    /**
     * @dev Unsets a `bucket` in the bitmap under the `mask`.
     */
    function unsetBucket(BitMap storage bitmap, uint256 bucket, uint256 mask) internal {
        bitmap._data[bucket] &= mask;
    }
}
