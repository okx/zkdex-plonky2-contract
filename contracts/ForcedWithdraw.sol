// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.8.24;

import "./components/MainStorage.sol";
import "./components/ActionHash.sol";
import "./components/Freezable.sol";

/// @notice refer to https://docs.starkware.co/starkex/spot/shared/forced-operations_overview.html
contract ForcedWithdraw is MainStorage, ActionHash, Freezable {

    event LogSpotForcedWithdrawalRequest(
        uint256 accountId,
        uint256 assetId
    );


    /// TODO: add modifier onlyKeyOwner(accountId): msg.sender = the ethAddress related to accountId
    /// @notice The user sends the forced withdraw reqeust to the contract.
    function spotForcedWithdrawalRequest(
        uint256 accountId,
        uint256 assetId
    ) external {

        // We cannot handle two identical forced withdraw request at the same time.
        require(
            getSpotForcedWithdrawalRequest(accountId, assetId) == 0,
            "REQUEST_ALREADY_PENDING"
        );

        // Start timer on escape request.
        setSpotForcedWithdrawalRequest(accountId, assetId);

        // Log request.
        emit LogSpotForcedWithdrawalRequest(accountId, assetId);
    }

    /// the user could freeze contract if the operator does not fulfil the withdrawal reqeust;
    function freezeRequest(
        uint256 accountId,
        uint256 assetId
    ) external notFrozen {
        // Verify position ID in range.
        // TODO: check accountId & assetId in range

        // Load request time.
        uint256 requestTime = getSpotForcedWithdrawalRequest(
            accountId,
            assetId
        );

        validateFreezeRequest(requestTime);
        freeze();
    }

    function spotForcedWithdrawActionHash(
        uint256 accountId,
        uint256 assetId
    ) internal pure returns (bytes32) {
        return
            getActionHash(
                "SPOT_FULL_WITHDRAWAL",
                abi.encode(accountId, assetId)
            );
    }

    /// @notice Implemented in the FullWithdrawal contracts.
    function clearSpotForcedWithdrawalRequest(
        uint256 accountId,
        uint256 assetId
    ) internal virtual {
        bytes32 actionHash = spotForcedWithdrawActionHash(accountId, assetId);
        require(forcedActionRequests[actionHash] != 0, "NON_EXISTING_ACTION");
        delete forcedActionRequests[actionHash];
    }

    function getSpotForcedWithdrawalRequest(
        uint256 accountId,
        uint256 assetId
    ) public view returns (uint256) {
        // Return request value. Expect zero if the request doesn't exist or has been serviced, and
        // a non-zero value otherwise.
        return
            forcedActionRequests[
                spotForcedWithdrawActionHash(accountId, assetId)
            ];
    }

    function setSpotForcedWithdrawalRequest(
        uint256 positionId,
        uint256 assetId
    ) internal {
        // FullWithdrawal is always at premium cost, hence the `true`.
        setActionHash(spotForcedWithdrawActionHash(positionId, assetId), true);
    }
}
