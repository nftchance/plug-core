// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import { ECDSA } from "solady/src/utils/ECDSA.sol";

/**
 * @title Plug:PlugTypes
 * @notice The base EIP-712 types that power a modern intent framework.
 * @dev This file was auto-generated by @nftchance/plug-types/cli
 *      and should not be edited directly otherwise the alchemy
 *      will fail and you will have to pay with a piece of your soul.
 *      (https://github.com/nftchance/plug-types)
 * @dev This interface and the consuming abstract are auto-generated by
 *      types declared in the framework configuration at (./config.ts).
 *      As an extensible base, all projects build on top of Pins
 *      and Plugs.
 * @author @nftchance
 * @author @nftchance/plug-types (2024-04-02)
 */
library PlugTypesLib {
    /**
     * @notice This struct is used to encode EIP712Domain data into a hash and
     *         decode EIP712Domain data from a hash.
     *
     * @dev EIP712Domain extends EIP712<{
     *      { name: 'name', type: 'string' }
     * 		{ name: 'version', type: 'string' }
     * 		{ name: 'chainId', type: 'uint256' }
     * 		{ name: 'verifyingContract', type: 'address' }
     * }>
     */
    struct EIP712Domain {
        string name;
        string version;
        uint256 chainId;
        address verifyingContract;
    }

    /**
     * @notice This struct is used to encode Current data into a hash and
     *         decode Current data from a hash.
     *
     * @dev Current extends EIP712<{
     *      { name: 'target', type: 'address' }
     * 		{ name: 'value', type: 'uint256' }
     * 		{ name: 'data', type: 'bytes' }
     * }>
     */
    struct Current {
        address target;
        uint256 value;
        bytes data;
    }

    /**
     * @notice This struct is used to encode Fuse data into a hash and
     *         decode Fuse data from a hash.
     *
     * @dev Fuse extends EIP712<{
     *      { name: 'target', type: 'address' }
     * 		{ name: 'data', type: 'bytes' }
     * }>
     */
    struct Fuse {
        address target;
        bytes data;
    }

    /**
     * @notice This struct is used to encode Plug data into a hash and
     *         decode Plug data from a hash.
     *
     * @dev Plug extends EIP712<{
     *      { name: 'current', type: 'Current' }
     * 		{ name: 'fuses', type: 'Fuse[]' }
     * }>
     */
    struct Plug {
        Current current;
        Fuse[] fuses;
    }

    /**
     * @notice This struct is used to encode Plugs data into a hash and
     *         decode Plugs data from a hash.
     *
     * @dev Plugs extends EIP712<{
     *      { name: 'socket', type: 'address' }
     * 		{ name: 'plugs', type: 'Plug[]' }
     * 		{ name: 'salt', type: 'bytes32' }
     * 		{ name: 'fee', type: 'uint256' }
     * 		{ name: 'solver', type: 'bytes' }
     * }>
     */
    struct Plugs {
        address socket;
        Plug[] plugs;
        bytes32 salt;
        uint256 fee;
        bytes solver;
    }

    /**
     * @notice This struct is used to encode LivePlugs data into a hash and
     *         decode LivePlugs data from a hash.
     *
     * @dev LivePlugs extends EIP712<{
     *      { name: 'plugs', type: 'Plugs' }
     * 		{ name: 'signature', type: 'bytes' }
     * }>
     */
    struct LivePlugs {
        Plugs plugs;
        bytes signature;
    }
}

/**
 * @title Plug:PlugTypes
 * @dev This file was auto-generated by @nftchance/plug-types/cli.
 *      (https://github.com/nftchance/plug-types)
 * @dev This abstract contract is auto-generated and should not be edited directly
 *      however it should be directly inherited from in the consuming protocol
 *      to power the processing of generalized plugs.
 * @dev Contracts that inherit this one must implement the name() and version()
 *      functions to provide the domain separator for EIP-712 signatures.
 * @author @nftchance
 * @author @nftchance/plug-types (2024-04-02)
 */
abstract contract PlugTypes {
    /// @notice Use the ECDSA library for signature verification.
    using ECDSA for bytes32;

    /**
     * @notice Type hash representing the EIP712Domain data type providing EIP-712
     *         compatability for encoding and decoding.
     * @dev EIP712_DOMAIN_TYPEHASH extends TypeHash<EIP712<{
     *      { name: 'name', type: 'string' }
     *      { name: 'version', type: 'string' }
     *      { name: 'chainId', type: 'uint256' }
     *      { name: 'verifyingContract', type: 'address' }
     * }>>
     */
    bytes32 constant EIP712_DOMAIN_TYPEHASH =
        0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;

    /**
     * @notice Type hash representing the Current data type providing EIP-712
     *         compatability for encoding and decoding.
     * @dev CURRENT_TYPEHASH extends TypeHash<EIP712<{
     *      { name: 'target', type: 'address' }
     *      { name: 'value', type: 'uint256' }
     *      { name: 'data', type: 'bytes' }
     * }>>
     */
    bytes32 constant CURRENT_TYPEHASH =
        0x4e1a9992657cd2dadc8cf749c3a5665c35d836a6aa5e695a1b318d00ea261fa4;

    /**
     * @notice Type hash representing the Fuse data type providing EIP-712
     *         compatability for encoding and decoding.
     * @dev FUSE_TYPEHASH extends TypeHash<EIP712<{
     *      { name: 'target', type: 'address' }
     *      { name: 'data', type: 'bytes' }
     * }>>
     */
    bytes32 constant FUSE_TYPEHASH =
        0x6a2e1450f9194ecc5758aac2b0935794f6d5706adcdd5968d7006542aacaa463;

    /**
     * @notice Type hash representing the Plug data type providing EIP-712
     *         compatability for encoding and decoding.
     * @dev PLUG_TYPEHASH extends TypeHash<EIP712<{
     *      { name: 'current', type: 'Current' }
     *      { name: 'fuses', type: 'Fuse[]' }
     * }>>
     */
    bytes32 constant PLUG_TYPEHASH =
        0x92e7d74a30e1e523d60bcb5fbb30caa2f5fa9f5fbc4a5499c4e9b8b44b7640fd;

    /**
     * @notice Type hash representing the Plugs data type providing EIP-712
     *         compatability for encoding and decoding.
     * @dev PLUGS_TYPEHASH extends TypeHash<EIP712<{
     *      { name: 'socket', type: 'address' }
     *      { name: 'plugs', type: 'Plug[]' }
     *      { name: 'salt', type: 'bytes32' }
     *      { name: 'fee', type: 'uint256' }
     *      { name: 'solver', type: 'bytes' }
     * }>>
     */
    bytes32 constant PLUGS_TYPEHASH =
        0xaf14e4c1bb28a29db968085ec12ac09da776141d37392d0c88184a4f3872c45c;

    /**
     * @notice Type hash representing the LivePlugs data type providing EIP-712
     *         compatability for encoding and decoding.
     * @dev LIVE_PLUGS_TYPEHASH extends TypeHash<EIP712<{
     *      { name: 'plugs', type: 'Plugs' }
     *      { name: 'signature', type: 'bytes' }
     * }>>
     */
    bytes32 constant LIVE_PLUGS_TYPEHASH =
        0xe8b38e73c38238f5d551461957d55a6fe8f9956b61952de931fefb9f6126661e;
    /**
     * @notice Name used for the domain separator.
     * @dev This is implemented this way so that it is easy
     *      to retrieve the value and sign the built message.
     * @return $name The name of the contract.
     */

    function name()
        public
        pure
        virtual
        returns (string memory $name);

    /**
     * @notice Version used for the domain separator.
     * @dev This is implemented this way so that it is easy
     *      to retrieve the value and sign the built message.
     * @return $version The version of the contract.
     */
    function version()
        public
        pure
        virtual
        returns (string memory $version);

    /**
     * @notice The symbol of the Socket only used for metadata purposes.
     * @dev This value is not used in the domain hash for signatures/EIP-712.
     *      You do not need to override this function as it will always
     *      automatically generate the symbol based on the override
     *      using the uppercase letters of the name.
     * @dev This is implement in assembly simply because Solidity does not
     *      have dynamic memory arrays and it is the most efficient way
     *      to generate the symbol.
     * @return $symbol The symbol of the Socket.
     */
    function symbol()
        public
        view
        virtual
        returns (string memory $symbol)
    {
        string memory $name = name();

        assembly {
            let len := mload($name)
            let result := mload(0x40)
            mstore(result, len)
            let data := add($name, 0x20)
            let resData := add(result, 0x20)

            let count := 0
            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                let char := byte(0, mload(add(data, i)))
                if and(gt(char, 0x40), lt(char, 0x5B)) {
                    mstore8(add(resData, count), char)
                    count := add(count, 1)
                }
            }

            if gt(count, 5) { count := 5 }
            if iszero(count) {
                mstore(resData, 0x504C554753)
                /// @dev "PLUGS"
                count := 4
            }
            mstore(result, count)
            mstore(0x40, add(add(result, count), 0x20))

            $symbol := result
        }
    }

    /**
     * @notice Encode EIP712Domain data into a packet hash and verify decoded EIP712Domain data
     *         from a packet hash to verify type compliance.
     * @param $input The EIP712Domain data to encode.
     * @return $hash The packet hash of the encoded EIP712Domain data.
     */
    function getEIP712DomainHash(
        PlugTypesLib.EIP712Domain memory $input
    )
        public
        pure
        virtual
        returns (bytes32 $hash)
    {
        $hash = keccak256(
            abi.encode(
                EIP712_DOMAIN_TYPEHASH,
                keccak256(bytes($input.name)),
                keccak256(bytes($input.version)),
                $input.chainId,
                $input.verifyingContract
            )
        );
    }

    /**
     * @notice Encode Current data into a packet hash and verify decoded Current data
     *         from a packet hash to verify type compliance.
     * @param $input The Current data to encode.
     * @return $hash The packet hash of the encoded Current data.
     */
    function getCurrentHash(PlugTypesLib.Current memory $input)
        public
        pure
        virtual
        returns (bytes32 $hash)
    {
        $hash = keccak256(
            abi.encode(
                CURRENT_TYPEHASH,
                $input.target,
                $input.value,
                keccak256($input.data)
            )
        );
    }

    /**
     * @notice Encode Fuse data into a packet hash and verify decoded Fuse data
     *         from a packet hash to verify type compliance.
     * @param $input The Fuse data to encode.
     * @return $hash The packet hash of the encoded Fuse data.
     */
    function getFuseHash(PlugTypesLib.Fuse memory $input)
        public
        pure
        virtual
        returns (bytes32 $hash)
    {
        $hash = keccak256(
            abi.encode(
                FUSE_TYPEHASH, $input.target, keccak256($input.data)
            )
        );
    }

    /**
     * @notice Encode Plug data into a packet hash and verify decoded Plug data
     *         from a packet hash to verify type compliance.
     * @param $input The Plug data to encode.
     * @return $hash The packet hash of the encoded Plug data.
     */
    function getPlugHash(PlugTypesLib.Plug memory $input)
        public
        pure
        virtual
        returns (bytes32 $hash)
    {
        $hash = keccak256(
            abi.encode(
                PLUG_TYPEHASH,
                getCurrentHash($input.current),
                getFuseArrayHash($input.fuses)
            )
        );
    }

    /**
     * @notice Encode Fuse[] data into hash and verify the
     *         decoded Fuse[] data from a packet hash to verify type compliance.
     * @param $input The Fuse[] data to encode.
     * @return $hash The packet hash of the encoded Fuse[] data.
     */
    function getFuseArrayHash(PlugTypesLib.Fuse[] memory $input)
        public
        pure
        virtual
        returns (bytes32 $hash)
    {
        /// @dev Load the stack.
        bytes memory encoded;
        uint256 i;
        uint256 length = $input.length;

        /// @dev Encode each item in the array.
        for (i; i < length; i++) {
            encoded = bytes.concat(encoded, getFuseHash($input[i]));
        }

        /// @dev Hash the encoded array.
        $hash = keccak256(encoded);
    }

    /**
     * @notice Encode Plugs data into a packet hash and verify decoded Plugs data
     *         from a packet hash to verify type compliance.
     * @param $input The Plugs data to encode.
     * @return $hash The packet hash of the encoded Plugs data.
     */
    function getPlugsHash(PlugTypesLib.Plugs memory $input)
        public
        pure
        virtual
        returns (bytes32 $hash)
    {
        $hash = keccak256(
            abi.encode(
                PLUGS_TYPEHASH,
                $input.socket,
                getPlugArrayHash($input.plugs),
                $input.salt,
                $input.fee,
                keccak256($input.solver)
            )
        );
    }

    /**
     * @notice Encode Plug[] data into hash and verify the
     *         decoded Plug[] data from a packet hash to verify type compliance.
     * @param $input The Plug[] data to encode.
     * @return $hash The packet hash of the encoded Plug[] data.
     */
    function getPlugArrayHash(PlugTypesLib.Plug[] memory $input)
        public
        pure
        virtual
        returns (bytes32 $hash)
    {
        /// @dev Load the stack.
        bytes memory encoded;
        uint256 i;
        uint256 length = $input.length;

        /// @dev Encode each item in the array.
        for (i; i < length; i++) {
            encoded = bytes.concat(encoded, getPlugHash($input[i]));
        }

        /// @dev Hash the encoded array.
        $hash = keccak256(encoded);
    }

    /**
     * @notice Encode LivePlugs data into a packet hash and verify decoded LivePlugs data
     *         from a packet hash to verify type compliance.
     * @param $input The LivePlugs data to encode.
     * @return $hash The packet hash of the encoded LivePlugs data.
     */
    function getLivePlugsHash(PlugTypesLib.LivePlugs memory $input)
        public
        pure
        virtual
        returns (bytes32 $hash)
    {
        $hash = keccak256(
            abi.encode(
                LIVE_PLUGS_TYPEHASH,
                getPlugsHash($input.plugs),
                keccak256($input.signature)
            )
        );
    }
}
