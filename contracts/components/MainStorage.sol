// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.8.24;

contract MainStorage {
    address tokenAddress;

    bool stateFrozen; // NOLINT: constable-states.
    // Time when unFreeze can be successfully called (UNFREEZE_DELAY after freeze).
    uint256 unFreezeTime; // NOLINT: constable-states.
    // The time required to freeze the exchange, in the case the operator does not execute a
    // requested full withdrawal.
    uint256 public constant FREEZE_GRACE_PERIOD = 7 days;
    // The time after which the exchange may be unfrozen after it froze. This should be enough time
    // for users to perform escape hatches to get back their funds.
    uint256 public constant UNFREEZE_DELAY = 365 days;

    uint8 accountTreeHeight = 32; // NOLINT: constable-states uninitialized-state.

    // Pending deposits.
    // A map asset id => account id => quantized amount.
    mapping(uint256 => mapping(uint256 => uint256)) pendingDeposits;
    // Pending withdrawals.
    // A map asset id => account id => quantized amount.
    mapping(uint256 => mapping(uint256 => uint256)) pendingWithdrawals;

    // Mapping from accountId to the Ethereum public key of its owner.
    mapping(uint256 => address) ethKeys; // NOLINT: uninitialized-state.

    // ForcedAction requests: actionHash => requested block time.
    mapping(bytes32 => uint256) forcedActionRequests;

    // Append only list of requested forced action hashes.
    bytes32[] actionHashList;

    // Counter of forced action request in block. The key is the block number.
    mapping(uint256 => uint256) forcedRequestsInBlock;
}