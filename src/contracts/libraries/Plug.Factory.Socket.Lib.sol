// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

library PlugFactorySocketLib {
	event SocketDeployed(
		address indexed $implementation,
		address indexed $vault,
		bytes32 $salt
	);
}