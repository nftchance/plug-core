//SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

/// @dev Shape declarations in the Plug framework.
import { PlugTypesLib } from "../abstracts/Plug.Types.sol";

interface PlugSocketInterface {
    /**
     * @notice Initialize the Socket with the ownership proxy of the Socket.
     * @param $ownership The address of the owner of the Socket.
     * @param $router The address of the Router that has permission to orchestate
     *                the execution of intents.
     */
    function initialize(address $ownership, address $router) external;

    /**
     * @notice Allows anyone to submit a plugs of signed plugs for processing.
     * @notice This version of the function will always be called by the Router.
     * @param $livePlugs The Plug bundle to execute.
     * @param $solver The address of the Solver.
     * @param $gas The gas to execute the plugs.
     * @return $results The return data of each plug executed.
     */
    function plug(
        PlugTypesLib.LivePlugs calldata $livePlugs,
        address $solver,
        uint256 $gas
    )
        external
        payable
        returns (PlugTypesLib.Result[] memory $results);

    /**
     * @notice Allows anyone to submit a plugs of signed plugs for processing.
     * @notice This version of the function will always be called by the Router.
     * @param $plugs The Plug bundle to execute.
     * @return $results The return data of each plug executed.
     */
    function plug(PlugTypesLib.Plugs calldata $plugs)
        external
        payable
        returns (PlugTypesLib.Result[] memory $results);

    /**
     * @notice Revoke a bundle of Plugs to prevent future use.
     * @dev This function must be implemented in non-abstract implementations
     *      of the Socket so that revocation is always allowed.
     * @param $plugsHash The hash of the Plugs to revoke.
     * @param $isRevoked The state to set the Plugs to.
     */
    function revoke(bytes32 $plugsHash, bool $isRevoked) external;
}
