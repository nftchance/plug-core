// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { ImmutableCreate2Factory } from
    "../interfaces/Deployment.Create2Factory.Interface.sol";
import { PlugLib } from "../libraries/Plug.Lib.sol";
/// @auto INSERT IMPORTS

/**
 * @title Plug Etcher Template
 * @notice This contract is the basis of the automatically generated Plug Etcher
 *         contract used to deploy and write the proper addresses. If you need to add
 *         a new etch into the vm stack for testing, you will do so through the file
 *         found at: /lib/functions/etcher.ts
 * @notice A good portion of this model comes from:
 *         https://github.com/Vectorized/multicaller/blob/main/src/MulticallerEtcher.sol
 *         I am not a Foundry expert. If there is a better way to do this, please let me
 *         know because this is a lot of work just to get a contract deployed when you're
 *         doing anything more than a simple in-and-out contract.
 * @author vectorized (twitter:@optimizoor)
 */
library PlugEtcherLibTemplate {
    /// @notice The immutable Create2 factory used for deployment.
    ImmutableCreate2Factory internal constant FACTORY =
        ImmutableCreate2Factory(0x0000000000FFe8B47B3e2130213B802212439497);

    /// @auto INSERT SEGMENTS

    /**
     * @notice Deploys a contract via 0age's immutable create 2 factory for testing.
     * @param $salt The salt to use for the deployment.
     * @param $initializationCode The initialization code for the contract.
     * @return $deployment The address of the deployed contract.
     */
    function _safeCreate2(
        bytes32 $salt,
        bytes memory $initializationCode
    )
        private
        returns (address $deployment)
    {
        // Canonical address of 0age's immutable create 2 factory.
        address c2f = 0x0000000000FFe8B47B3e2130213B802212439497;
        if (_extcodesize(c2f) == 0) {
            bytes memory ic2fBytecode =
                hex"60806040526004361061003f5760003560e01c806308508b8f1461004457806364e030871461009857806385cf97ab14610138578063a49a7c90146101bc575b600080fd5b34801561005057600080fd5b506100846004803603602081101561006757600080fd5b503573ffffffffffffffffffffffffffffffffffffffff166101ec565b604080519115158252519081900360200190f35b61010f600480360360408110156100ae57600080fd5b813591908101906040810160208201356401000000008111156100d057600080fd5b8201836020820111156100e257600080fd5b8035906020019184600183028401116401000000008311171561010457600080fd5b509092509050610217565b6040805173ffffffffffffffffffffffffffffffffffffffff9092168252519081900360200190f35b34801561014457600080fd5b5061010f6004803603604081101561015b57600080fd5b8135919081019060408101602082013564010000000081111561017d57600080fd5b82018360208201111561018f57600080fd5b803590602001918460018302840111640100000000831117156101b157600080fd5b509092509050610592565b3480156101c857600080fd5b5061010f600480360360408110156101df57600080fd5b508035906020013561069e565b73ffffffffffffffffffffffffffffffffffffffff1660009081526020819052604090205460ff1690565b600083606081901c33148061024c57507fffffffffffffffffffffffffffffffffffffffff0000000000000000000000008116155b6102a1576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260458152602001806107746045913960600191505060405180910390fd5b606084848080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920182905250604051855195965090943094508b93508692506020918201918291908401908083835b6020831061033557805182527fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe090920191602091820191016102f8565b51815160209384036101000a7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff018019909216911617905260408051929094018281037fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe00183528085528251928201929092207fff000000000000000000000000000000000000000000000000000000000000008383015260609890981b7fffffffffffffffffffffffffffffffffffffffff00000000000000000000000016602183015260358201969096526055808201979097528251808203909701875260750182525084519484019490942073ffffffffffffffffffffffffffffffffffffffff81166000908152938490529390922054929350505060ff16156104a7576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040180806020018281038252603f815260200180610735603f913960400191505060405180910390fd5b81602001825188818334f5955050508073ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff161461053a576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260468152602001806107b96046913960600191505060405180910390fd5b50505073ffffffffffffffffffffffffffffffffffffffff8116600090815260208190526040902080547fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff001660011790559392505050565b6000308484846040516020018083838082843760408051919093018181037fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe001825280845281516020928301207fff000000000000000000000000000000000000000000000000000000000000008383015260609990991b7fffffffffffffffffffffffffffffffffffffffff000000000000000000000000166021820152603581019790975260558088019890985282518088039098018852607590960182525085519585019590952073ffffffffffffffffffffffffffffffffffffffff81166000908152948590529490932054939450505060ff909116159050610697575060005b9392505050565b604080517fff000000000000000000000000000000000000000000000000000000000000006020808301919091523060601b6021830152603582018590526055808301859052835180840390910181526075909201835281519181019190912073ffffffffffffffffffffffffffffffffffffffff81166000908152918290529190205460ff161561072e575060005b9291505056fe496e76616c696420636f6e7472616374206372656174696f6e202d20636f6e74726163742068617320616c7265616479206265656e206465706c6f7965642e496e76616c69642073616c74202d206669727374203230206279746573206f66207468652073616c74206d757374206d617463682063616c6c696e6720616464726573732e4661696c656420746f206465706c6f7920636f6e7472616374207573696e672070726f76696465642073616c7420616e6420696e697469616c697a6174696f6e20636f64652ea265627a7a723058202bdc55310d97c4088f18acf04253db593f0914059f0c781a9df3624dcef0d1cf64736f6c634300050a0032";
            /// @solidity memory-safe-assembly
            assembly {
                let m := mload(0x40)
                mstore(m, 0xb4d6c782) // `etch(address,bytes)`.
                mstore(add(m, 0x20), c2f)
                mstore(add(m, 0x40), 0x40)
                let n := mload(ic2fBytecode)
                mstore(add(m, 0x60), n)
                for { let i := 0 } lt(i, n) { i := add(0x20, i) } {
                    mstore(
                        add(add(m, 0x80), i),
                        mload(add(add(ic2fBytecode, 0x20), i))
                    )
                }
                let vmAddress := 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D
                if iszero(
                    call(
                        gas(),
                        vmAddress,
                        0,
                        add(m, 0x1c),
                        add(n, 0x64),
                        0x00,
                        0x00
                    )
                ) { revert(0, 0) }
            }
        }
        /// @solidity memory-safe-assembly
        assembly {
            let m := mload(0x40)
            let n := mload($initializationCode)
            mstore(m, 0x64e03087) // `safeCreate2(bytes32,bytes)`.
            mstore(add(m, 0x20), $salt)
            mstore(add(m, 0x40), 0x40)
            mstore(add(m, 0x60), n)
            // prettier-ignore
            for { let i := 0 } lt(i, n) { i := add(i, 0x20) } {
                mstore(
                    add(add(m, 0x80), i),
                    mload(add(add($initializationCode, 0x20), i))
                )
            }
            if iszero(call(gas(), c2f, 0, add(m, 0x1c), add(n, 0x64), m, 0x20))
            {
                returndatacopy(m, m, returndatasize())
                revert(m, returndatasize())
            }
            $deployment := mload(m)
        }
    }

    /**
     * @notice Determine and retrieve the extcodesize of `deployment`.
     * @param $deployment The address to check.
     * @return $result The size of the code at `deployment`.
     */
    function _extcodesize(address $deployment)
        private
        view
        returns (uint256 $result)
    {
        /// @solidity memory-safe-assembly
        assembly {
            $result := extcodesize($deployment)
        }
    }
}
