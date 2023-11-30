// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.19;

import {IFuse} from '../interfaces/IFuse.sol';
import {PlugErrors} from '../libraries/Plug.Errors.sol';
import {Types} from './Plug.Types.sol';

/**
 * @title Plug Core
 * @notice The core contract for the Plug framework that enables
 *         counterfactual revokable pin of extremely
 *         granular pin and execution paths.
 * @author @nftchance
 * @author @danfinlay (https://github.com/delegatable/delegatable-sol)
 * @author @KamesGeraghty (https://github.com/kamescg)
 */
abstract contract PlugCore is Types {
	using PlugErrors for bytes;

	/// @notice Multi-dimensional account pin nonce management.
	mapping(address => mapping(uint256 => uint256)) public nonce;

	/**
	 * @notice Load the Core alongside all the Types driving
	 *         the parent consumer.
	 * @param $name The name of the contract
	 * @param $version The version of the contract
	 */
	constructor(
		string memory $name,
		string memory $version
	) Types($name, $version) {}

	/**
	 * @notice Determine the address representing the message sender in the
	 *         current context. This is important for pins, as the
	 *         message sender may be the framework itself, in which case
	 *         the sender must be extracted from the data.
	 * @dev Because of this function, when building on top of the framework,
	 *      you should never use `msg.sender` directly, but instead use
	 *      `_msgSender()`, which will correctly identify the sender whether
	 *      it's the framework or an external account.
	 * @return $sender The address of the message sender.
	 */
	function _msgSender() internal view virtual returns (address $sender) {
		/// @dev If the message sender is the framework, we need to extract the
		///      sender from the data.
		if (msg.sender == address(this)) {
			/// @dev Load the data as a hot reference.
			bytes memory array = msg.data;

			/// @dev Load the length of the data as a hot reference.
			uint256 index = array.length;

			assembly {
				/// @dev Load the sender from the data by applying a
				///      bitwise AND operation to the data and the
				///      maximum uint256 value, keeping only the last
				///      20 bytes (160 bits) (address size).
				$sender := and(
					/// @dev Load the bytes at the computer pointer.
					mload(
						/// @dev Computes the sum of the starting address of array and index.
						///      This effectively points to the end of array.
						add(array, index)
					),
					0xffffffffffffffffffffffffffffffffffffffff
				)
			}
		}
		/// @dev Otherwise, the sender is the message sender.
		else $sender = msg.sender;
	}

	/**
	 * @notice Update the nonce for a given account and queue.
	 * @param $intendedSender The address of the intended sender.
	 * @param $protection The replay protection struct.
	 */
	function _enforceBreaker(
		address $intendedSender,
		Breaker memory $protection
	) internal {
		/// @dev Ensure the nonce is in order.
		require(
			$protection.nonce == ++nonce[$intendedSender][$protection.queue],
			'PlugCore:nonce2-out-of-order'
		);
	}

	/**
	 * @notice Execution a built transaction.
	 * @param $to The address of the contract to execute.
	 * @param $data The data to execute on the contract.
	 * @param $voltage The gas limit for the transaction.
	 * @param $sender The address of the sender.
	 * @return $success Whether the transaction was successfully executed.
	 */
	function _execute(
		address $to,
		bytes memory $data,
		uint256 $voltage,
		address $sender
	) internal returns (bool $success) {
		/// @dev Build the final call data.
		bytes memory full = abi.encodePacked($data, $sender);

		/// @dev Warm up the slot for the return data.
		bytes memory errorMessage;

		/// @dev Make the external call that was delegated.
		($success, errorMessage) = address($to).call{gas: $voltage}(full);

		/// @dev If the call failed, bubble up the revert reason if possible.
		if ($success == false) errorMessage.bubbleRevert();
	}

	/**
	 * @notice Execute a plugs of plugs
	 * @param $plugs The plugs of plugs to execute.
	 * @param $sender The address of the sender.
	 * @return $success Whether the transaction was successfully executed.
	 */
	function _plug(
		Plug[] calldata $plugs,
		address $sender
	) internal returns (bool $success) {
		/// @dev Load the stack.
		uint256 i;
		uint256 j;
		uint256 k;
		address canGrant;
		address intendedSender;
		address pinSigner;
		bytes32 authHash;
		bytes32 pinHash;
		bytes memory callback;

		/// @dev Load the structs into a hot reference.
		Plug memory intent;
		LivePin memory signedPin;
		Pin memory pin;
		Current memory current;

		/// @dev Iterate over the plugs of plugs.
		for (i; i < $plugs.length; ) {
			/// @dev Load the intent from the plugs.
			intent = $plugs[i];

			/// @dev If there are no pins, this intent comes from the signer
			if (intent.pins.length == 0) {
				canGrant = intendedSender = $sender;
			}

			/// @dev Reset the hot reference to the authHash.
			authHash = 0x0;
			j = 0;
			k = 0;

			/// @dev Load the transaction from the intent.
			current = intent.current;

			require(
				current.ground == address(this),
				'PlugCore:invalid-intent-target'
			);

			/// @dev Iterate over the authority pins.
			for (j; j < intent.pins.length; j++) {
				/// @dev Load the pin from the intent.
				signedPin = intent.pins[j];

				/// @dev Determine the signer of the pin.
				pinSigner = getLivePinSigner(signedPin);

				/// @dev Implied sending account is the signer of the first pin.
				if (j == 0) canGrant = intendedSender = pinSigner;

				/// @dev Ensure the pin signer has authority to grant
				///      the claimed pin.
				require(pinSigner == canGrant, 'PlugCore:invalid-pin-signer');

				/// @dev Warm up the pin reference.
				pin = signedPin.pin;

				/// @dev Ensure the pin is valid.
				require(
					pin.live == authHash,
					'PlugCore:invalid-authority-pin-link'
				);

				/// @dev Retrieve the packet hash for the pin.
				pinHash = getLivePinHash(signedPin);

				/// @dev Loop through all the execution fuses declared in the pin
				///      and ensure they are all valid.
				for (k; k < pin.fuses.length; ) {
					/// @dev Call the enforcer to determine if the fuse is valid.
					callback = IFuse(pin.fuses[k].neutral).enforceFuse(
						pin.fuses[k].live,
						intent.current,
						pinHash
					);

					if (callback.length > 0) revert('PlugCore:not-implemented');

					unchecked {
						++k;
					}
				}

				/// @dev Store the hash of this pin in `authHash` to verify the
				///      next pin can be verified against it.
				authHash = pinHash;

				/// @dev Set the next pin signer as the current pin signer.
				canGrant = pin.neutral;
			}

			/// @dev Verify the delegate at the end of the pin chain is the signer.
			require(canGrant == $sender, 'PlugCore:invalid-signer');

			/// @dev Execute the transaction.
			$success = _execute(
				current.ground,
				current.data,
				current.voltage,
				intendedSender
			);

			unchecked {
				++i;
			}
		}
	}
}