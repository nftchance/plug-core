// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import {ECDSA} from 'solady/src/utils/ECDSA.sol';

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
 * @author @nftchance/plug-types (2024-03-11)
 */
library PlugTypesLib {
    /**
     * @notice This struct is used to encode EIP712Domain data into a hash and
     *         decode EIP712Domain data from a hash.
     * 
     * @dev EIP712Domain extends EIP712<{
     * 		{ name: 'name', type: 'string' }
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
     * 		{ name: 'target', type: 'address' }
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
     * 		{ name: 'target', type: 'address' }
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
     * 		{ name: 'current', type: 'Current' }
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
     * 		{ name: 'socket', type: 'address' }
     * 		{ name: 'plugs', type: 'Plug[]' }
     * 		{ name: 'salt', type: 'bytes32' }
     * 		{ name: 'fee', type: 'uint256' }
     * 		{ name: 'maxFeePerGas', type: 'uint256' }
     * 		{ name: 'maxPriorityFeePerGas', type: 'uint256' }
     * 		{ name: 'executor', type: 'address' }
     * }>
     */
    struct Plugs {
	address socket;
	Plug[] plugs;
	bytes32 salt;
	uint256 fee;
	uint256 maxFeePerGas;
	uint256 maxPriorityFeePerGas;
	address executor;
    }

    /**
     * @notice This struct is used to encode LivePlugs data into a hash and
     *         decode LivePlugs data from a hash.
     * 
     * @dev LivePlugs extends EIP712<{
     * 		{ name: 'plugs', type: 'Plugs' }
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
 * @author @nftchance/plug-types (2024-03-11)
 */
abstract contract PlugTypes {
    /// @notice Use the ECDSA library for signature verification.
    using ECDSA for bytes32;

    /// @notice The hash of the domain separator used in the EIP712 domain hash.
    bytes32 public domainHash;
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
    bytes32 constant EIP712_DOMAIN_TYPEHASH = keccak256(
        'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
    );

    /**
     * @notice Type hash representing the Current data type providing EIP-712
     *         compatability for encoding and decoding.
     * @dev CURRENT_TYPEHASH extends TypeHash<EIP712<{
     *      { name: 'target', type: 'address' }
     *      { name: 'value', type: 'uint256' }
     *      { name: 'data', type: 'bytes' } 
     * }>>
     */
    bytes32 constant CURRENT_TYPEHASH = keccak256(
        'Current(address target,uint256 value,bytes data)'
    );

    /**
     * @notice Type hash representing the Fuse data type providing EIP-712
     *         compatability for encoding and decoding.
     * @dev FUSE_TYPEHASH extends TypeHash<EIP712<{
     *      { name: 'target', type: 'address' }
     *      { name: 'data', type: 'bytes' } 
     * }>>
     */
    bytes32 constant FUSE_TYPEHASH = keccak256(
        'Fuse(address target,bytes data)'
    );

    /**
     * @notice Type hash representing the Plug data type providing EIP-712
     *         compatability for encoding and decoding.
     * @dev PLUG_TYPEHASH extends TypeHash<EIP712<{
     *      { name: 'current', type: 'Current' }
     *      { name: 'fuses', type: 'Fuse[]' } 
     * }>>
     */
    bytes32 constant PLUG_TYPEHASH = keccak256(
        'Plug(Current current,Fuse[] fuses)Current(address target,uint256 value,bytes data)Fuse(address target,bytes data)'
    );

    /**
     * @notice Type hash representing the Plugs data type providing EIP-712
     *         compatability for encoding and decoding.
     * @dev PLUGS_TYPEHASH extends TypeHash<EIP712<{
     *      { name: 'socket', type: 'address' }
     *      { name: 'plugs', type: 'Plug[]' }
     *      { name: 'salt', type: 'bytes32' }
     *      { name: 'fee', type: 'uint256' }
     *      { name: 'maxFeePerGas', type: 'uint256' }
     *      { name: 'maxPriorityFeePerGas', type: 'uint256' }
     *      { name: 'executor', type: 'address' } 
     * }>>
     */
    bytes32 constant PLUGS_TYPEHASH = keccak256(
        'Plugs(address socket,Plug[] plugs,bytes32 salt,uint256 fee,uint256 maxFeePerGas,uint256 maxPriorityFeePerGas,address executor)Current(address target,uint256 value,bytes data)Fuse(address target,bytes data)Plug(Current current,Fuse[] fuses)'
    );

    /**
     * @notice Type hash representing the LivePlugs data type providing EIP-712
     *         compatability for encoding and decoding.
     * @dev LIVE_PLUGS_TYPEHASH extends TypeHash<EIP712<{
     *      { name: 'plugs', type: 'Plugs' }
     *      { name: 'signature', type: 'bytes' } 
     * }>>
     */
    bytes32 constant LIVE_PLUGS_TYPEHASH = keccak256(
        'LivePlugs(Plugs plugs,bytes signature)Current(address target,uint256 value,bytes data)Fuse(address target,bytes data)Plug(Current current,Fuse[] fuses)Plugs(address socket,Plug[] plugs,bytes32 salt,uint256 fee,uint256 maxFeePerGas,uint256 maxPriorityFeePerGas,address executor)'
    );

    /**
     * @notice Initialize the contract with the name and version of the protocol.
     * @dev The chainId is pulled from the block and the verifying contract is set 
     *	    to the address of the contract.
     */
    function _initializePlug() internal virtual {
	if (domainHash != 0x0) 
            revert('PlugTypes:already-initialized');

        /// @dev Sets the domain hash for the contract.
        domainHash = getEIP712DomainHash(PlugTypesLib.EIP712Domain({
            name: name(),
            version: version(),
            chainId: block.chainid,
            verifyingContract: address(this)
        }));
    }

    /**
     * @notice Name used for the domain separator.
     * @dev This is implemented this way so that it is easy
     *      to retrieve the value and sign the built message.
     * @return $name The name of the contract.
     */
    function name() public pure virtual returns (string memory $name);

    /**
     * @notice Version used for the domain separator.
     * @dev This is implemented this way so that it is easy
     *      to retrieve the value and sign the built message.
     * @return $version The version of the contract.
     */
    function version() public pure virtual returns (string memory $version);

    /**
     * @notice This will use the name() and version() functions that you override
     *         when you inherit this contract to create a deployable Socket making
     *         retrieval of the domain used to sign much easier.
     * @dev When signing a message it is simplest to just call this function
     *      to retrieve the domain separator for the EIP-712 signature.
     * @return $domain The domain separator for EIP-712.
     */
    function domain()
        public
        view
        virtual
        returns (PlugTypesLib.EIP712Domain memory $domain)
    {
        $domain = PlugTypesLib.EIP712Domain({
            name: name(),
            version: version(),
            chainId: block.chainid,
            verifyingContract: address(this)
        });
    }

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
    function symbol() public view virtual returns (string memory $symbol) {
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
    ) public pure virtual returns (bytes32 $hash) {
        $hash = keccak256(abi.encode(
            EIP712_DOMAIN_TYPEHASH,
            keccak256(bytes($input.name)),
	    keccak256(bytes($input.version)),
	    $input.chainId,
	    $input.verifyingContract
        ));
    }

    /**
     * @notice Encode Current data into a packet hash and verify decoded Current data 
     *         from a packet hash to verify type compliance.
     * @param $input The Current data to encode.
     * @return $hash The packet hash of the encoded Current data.
     */
    function getCurrentHash(
        PlugTypesLib.Current memory $input
    ) public pure virtual returns (bytes32 $hash) {
        $hash = keccak256(abi.encode(
            CURRENT_TYPEHASH,
            $input.target,
	    $input.value,
	    keccak256($input.data)
        ));
    }

    /**
     * @notice Encode Fuse data into a packet hash and verify decoded Fuse data 
     *         from a packet hash to verify type compliance.
     * @param $input The Fuse data to encode.
     * @return $hash The packet hash of the encoded Fuse data.
     */
    function getFuseHash(
        PlugTypesLib.Fuse memory $input
    ) public pure virtual returns (bytes32 $hash) {
        $hash = keccak256(abi.encode(
            FUSE_TYPEHASH,
            $input.target,
	    keccak256($input.data)
        ));
    }

    /**
     * @notice Encode Plug data into a packet hash and verify decoded Plug data 
     *         from a packet hash to verify type compliance.
     * @param $input The Plug data to encode.
     * @return $hash The packet hash of the encoded Plug data.
     */
    function getPlugHash(
        PlugTypesLib.Plug memory $input
    ) public pure virtual returns (bytes32 $hash) {
        $hash = keccak256(abi.encode(
            PLUG_TYPEHASH,
            getCurrentHash($input.current),
	    getFuseArrayHash($input.fuses)
        ));
    }

    /**
     * @notice Encode Fuse[] data into hash and verify the 
     *         decoded Fuse[] data from a packet hash to verify type compliance.
     * @param $input The Fuse[] data to encode. 
     * @return $hash The packet hash of the encoded Fuse[] data.
     */
    function getFuseArrayHash(
        PlugTypesLib.Fuse[] memory $input
    )  public pure virtual returns (bytes32 $hash) {
        /// @dev Load the stack.
        bytes memory encoded;
        uint256 i;
        uint256 length = $input.length;

        /// @dev Encode each item in the array.
        for (i; i < length; i++) {
            encoded = bytes.concat(
                encoded,
                getFuseHash($input[i])
            );
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
    function getPlugsHash(
        PlugTypesLib.Plugs memory $input
    ) public pure virtual returns (bytes32 $hash) {
        $hash = keccak256(abi.encode(
            PLUGS_TYPEHASH,
            $input.socket,
	    getPlugArrayHash($input.plugs),
	    $input.salt,
	    $input.fee,
	    $input.maxFeePerGas,
	    $input.maxPriorityFeePerGas,
	    $input.executor
        ));
    }

    /**
     * @notice Encode Plug[] data into hash and verify the 
     *         decoded Plug[] data from a packet hash to verify type compliance.
     * @param $input The Plug[] data to encode. 
     * @return $hash The packet hash of the encoded Plug[] data.
     */
    function getPlugArrayHash(
        PlugTypesLib.Plug[] memory $input
    )  public pure virtual returns (bytes32 $hash) {
        /// @dev Load the stack.
        bytes memory encoded;
        uint256 i;
        uint256 length = $input.length;

        /// @dev Encode each item in the array.
        for (i; i < length; i++) {
            encoded = bytes.concat(
                encoded,
                getPlugHash($input[i])
            );
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
    function getLivePlugsHash(
        PlugTypesLib.LivePlugs memory $input
    ) public pure virtual returns (bytes32 $hash) {
        $hash = keccak256(abi.encode(
            LIVE_PLUGS_TYPEHASH,
            getPlugsHash($input.plugs),
	    keccak256($input.signature)
        ));
    }

    /**
     * @notice Encode Plugs data into a digest hash that has been 
     *         localized to the domain of the contract.
     * @param $input The Plugs data to encode.
     * @return $digest The digest hash of the encoded Plugs data.
     */
    function getPlugsDigest(
        PlugTypesLib.Plugs memory $input
    ) public view virtual returns (bytes32 $digest) {
        $digest = keccak256(
            bytes.concat(
                "\x19\x01",
                domainHash,
                getPlugsHash($input)
            )
        );
    }

    /**
     * @notice Get the signer of a LivePlugs data type.
     * @param $input The LivePlugs data to encode.
     * @return $signer The signer of the LivePlugs data.
     */
    function getLivePlugsSigner(
        PlugTypesLib.LivePlugs memory $input
    ) public view virtual returns (address $signer) {
        $signer = getPlugsDigest($input.plugs).recover(
            $input.signature
        );
    }
}