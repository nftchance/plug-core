//SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.19;

/// @dev Shape declarations in the Plug framework.
import {ITypes} from '../abstracts/Plug.Types.sol';

interface IPlug is ITypes {
	/**
	 * @notice Allows a smart contract to submit a plugs of plugs for processing,
	 *         allowing itself to be the delegate.
	 * @param $intent The plugs of plugs to execute.
	 * @return success Whether the plugs of intent was successfully processed.
	 */
	function plugContract(Plug[] calldata $intent) external returns (bool);

	/**
	 * @notice Allows anyone to submit a plugs of signed plugs for processing.
	 * @param $signedPlugs The plugs of signed plugs to process.
	 * @return success Whether the plugs of plugs was successfully processed.
	 */
	function plug(
		LivePlugs[] calldata $signedPlugs
	) external returns (bool success);
}