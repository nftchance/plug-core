//SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.19;

/// @dev Shape declarations in the Plug framework.
import {ITypes} from '../abstracts/Plug.Types.sol';

interface IFuse is ITypes {
	/**
	 * @notice Enforces a fuse on a transaction.
	 * @param $live The live wire the fuse is regulating.
	 * @param $current The current flowing through the fuse.
	 * @param $pinHash The hash of the pin.
	 */
	function enforceFuse(
		bytes calldata $live,
		Current calldata $current,
		bytes32 $pinHash
	) external returns (bytes calldata $callback);
}