// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PlugSocket} from '../abstracts/Plug.Socket.sol';
import {Ownable} from 'solady/src/auth/Ownable.sol';

contract PlugVaultSocket is PlugSocket, Ownable {
	constructor() {
		/// @dev Initialize the owner as zero.
		_initializeOwner(address(0));

		/// @dev The plug is not initialized here to prevent the
		/// 	 any messages from being relayed through here.
	}

	/**
	 * @notice Initialize a new Plug Vault.
	 * @param $owner The owner of the vault.
	 */
	function initialize(address $owner) external virtual {
		/// @dev Initialize the owner.
		_initializeOwner($owner);

		/// @dev Initialize the Plug Socket.
		_initializeSocket('PlugVaultSocket', '0.0.0');
	}

	/**
	 * @notice Prevent the initializer from being called multiple times. 	
	 * @return true if the initializer has already been called.
	 */
	function _guardInitializeOwner()
		internal
		pure
		virtual
		override
		returns (bool)
	{
		return true;
	}

	/**
	 * @notice Execute through the transaction on behalf of the owner.
	 * @param $to The address to execute the transaction on.
	 * @param $data The data to execute the transaction with.
	 * @param $value The value to execute the transaction with.
	 * @return $success The success of the transaction.
	 * @return $returnData The data returned from the transaction.
	 */
	function execute(
		address $to,
		bytes calldata $data,
		uint256 $value
	)
		public
		payable
		virtual
		onlyOwner
		returns (bool $success, bytes memory $returnData)
	{
		/// @dev Execute the transaction and bubble up the response.
		($success, $returnData) = $to.call{value: $value}($data);
	}
}