// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import {
    Test,
    PlugLib,
    PlugTypesLib,
    PlugMockERC20,
    PlugMockERC721
} from "../abstracts/test/Plug.Test.sol";
import { PlugBalance } from "./Plug.Balance.sol";

contract PlugBalanceTest is Test {
    PlugBalance internal connector;

    bytes32 plugsHash = bytes32(0);
    uint8 belowOperator;
    uint8 aboveOperator = 1;
    uint256 belowBalance = 100 + 1;
    uint256 aboveBalance = 100 - 1;
    uint256 balance = 100;

    function setUp() public virtual {
        setUpPlug();

        connector = new PlugBalance();

        vm.deal(address(this), balance);
        mockERC20.mint(address(this), balance);
        mockERC721.mint(address(this), balance);
    }

    function test_enforce_Encoding() public {
        bytes memory terms =
            connector.encode(address(this), address(0), belowOperator, belowBalance);
        (address decodedHolder, address decodedAsset, uint8 decodedOperator, uint256 decodedBalance)
        = connector.decode(terms);

        assertEq(decodedHolder, address(this));
        assertEq(decodedAsset, address(0));
        assertEq(decodedOperator, belowOperator);
        assertEq(decodedBalance, belowBalance);
    }

    function test_enforce_BelowNativeBalance() public view {
        bytes memory terms =
            connector.encode(address(this), address(0), belowOperator, belowBalance);
        connector.enforce(terms, plugsHash);
    }

    function test_enforce_BelowNativeBalance_Exceeded() public {
        uint256 expected = balance - 1;
        bytes memory terms = connector.encode(address(this), address(0), belowOperator, expected);
        vm.expectRevert(
            abi.encodeWithSelector(PlugLib.ThresholdExceeded.selector, expected, balance)
        );
        connector.enforce(terms, plugsHash);
    }

    function test_enforce_AboveNativeBalance() public view {
        bytes memory terms =
            connector.encode(address(this), address(0), aboveOperator, aboveBalance);
        connector.enforce(terms, plugsHash);
    }

    function testRevert_enforce_AboveNativeBalance_Insufficient() public {
        uint256 expected = balance + 1;
        bytes memory terms = connector.encode(address(this), address(0), aboveOperator, expected);
        vm.expectRevert(
            abi.encodeWithSelector(PlugLib.ThresholdInsufficient.selector, expected, balance)
        );
        connector.enforce(terms, plugsHash);
    }

    function test_enforce_BelowERC20Balance() public view {
        bytes memory terms =
            connector.encode(address(this), address(mockERC20), belowOperator, belowBalance);
        connector.enforce(terms, plugsHash);
    }

    function test_enforce_BelowERC20Balance_Exceeded() public {
        uint256 expected = balance - 1;
        bytes memory terms =
            connector.encode(address(this), address(mockERC20), belowOperator, expected);
        vm.expectRevert(
            abi.encodeWithSelector(PlugLib.ThresholdExceeded.selector, expected, balance)
        );
        connector.enforce(terms, plugsHash);
    }

    function test_enforce_AboveERC20Balance() public view {
        bytes memory terms =
            connector.encode(address(this), address(mockERC20), aboveOperator, aboveBalance);
        connector.enforce(terms, plugsHash);
    }

    function testRevert_enforce_AboveERC20Balance_Insufficient() public {
        uint256 expected = balance + 1;
        bytes memory terms =
            connector.encode(address(this), address(mockERC20), aboveOperator, expected);
        vm.expectRevert(
            abi.encodeWithSelector(PlugLib.ThresholdInsufficient.selector, expected, balance)
        );
        connector.enforce(terms, plugsHash);
    }

    function test_enforce_BelowERC721Balance() public view {
        bytes memory terms = connector.encode(address(this), address(mockERC721), belowOperator, 2);
        connector.enforce(terms, plugsHash);
    }

    function test_enforce_BelowERC721Balance_Exceeded() public {
        uint256 expected = 0;
        bytes memory terms =
            connector.encode(address(this), address(mockERC721), belowOperator, expected);
        vm.expectRevert(abi.encodeWithSelector(PlugLib.ThresholdExceeded.selector, expected, 1));
        connector.enforce(terms, plugsHash);
    }

    function test_enforce_AboveERC721Balance() public view {
        bytes memory terms = connector.encode(address(this), address(mockERC721), aboveOperator, 0);
        connector.enforce(terms, plugsHash);
    }

    function testRevert_enforce_AboveERC721Balance_Insufficient() public {
        uint256 expected = 1 + 1;
        bytes memory terms =
            connector.encode(address(this), address(mockERC721), aboveOperator, expected);
        vm.expectRevert(abi.encodeWithSelector(PlugLib.ThresholdInsufficient.selector, expected, 1));
        connector.enforce(terms, plugsHash);
    }
}
