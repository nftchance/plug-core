// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import { Test } from "../utils/Test.sol";

import { PlugTypesLib } from "../abstracts/Plug.Types.sol";
import { Plug } from "../base/Plug.sol";
import { PlugFactory } from "../base/Plug.Factory.sol";

import { PlugVaultSocket } from "./Plug.Vault.Socket.sol";
import { PlugMockEcho } from "../mocks/Plug.Mock.Echo.sol";
import { ERC721 } from "solady/src/tokens/ERC721.sol";

contract PlugVaultSocketTest is Test {
    PlugVaultSocket internal implementation;
    PlugVaultSocket internal vault;
    PlugFactory internal factory;
    PlugMockEcho internal mock;

    address internal signer;
    uint256 internal signerPrivateKey;

    function setUp() public virtual {
        signerPrivateKey = 0xabc123;
        signer = vm.addr(signerPrivateKey);

        implementation = new PlugVaultSocket();
        factory = new PlugFactory(
            _randomNonZeroAddress(), "https://onplug.io/metadata/"
        );

        bytes32 salt = bytes32(abi.encodePacked(address(this), uint96(0)));

        (, address vaultAddress) = factory.deploy(address(implementation), salt);
        vault = PlugVaultSocket(payable(vaultAddress));
    }

    function testRevert_Initialize_Again(uint256) public {
        vm.deal(address(vault), 100 ether);
        vm.expectRevert(bytes("PlugTrading:already-initialized"));
        vault.initialize(address(this));
    }

    function test_name() public {
        assertEq(vault.name(), "PlugVaultSocket");
    }

    function test_symbol() public {
        assertEq(vault.symbol(), "PVS");
    }

    function test_ownership_Implementation() public {
        assertEq(implementation.ownership(), address(1));
    }

    function test_owner() public {
        assertEq(vault.owner(), address(this));
    }

    function testRevert_owner_Implementation() public {
        vm.expectRevert();
        implementation.owner();
    }

    function test_transferOwnership_Token() public {
        address newOwner = _randomNonZeroAddress();
        ERC721(vault.ownership()).transferFrom(
            address(this), newOwner, uint256(uint160(address(vault)))
        );
    }

    function testRevert_transferOwnership_Direct() public {
        address newOwner = _randomNonZeroAddress();
        vm.expectRevert(bytes("PlugTrading:forbidden-caller"));
        vault.transferOwnership(newOwner);
    }

    function testRevert_transferOwnership_Unauthorized() public {
        vm.prank(_randomNonZeroAddress());
        vm.expectRevert(bytes("PlugTrading:forbidden-caller"));
        vault.transferOwnership(_randomNonZeroAddress());
    }
}
