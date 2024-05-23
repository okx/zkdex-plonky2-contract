// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.8.24;

import "./interfaces/IERC20.sol";
import "./interfaces/IGroth16Verifier.sol";
import "./libraries/Address.sol";
import "./components/MainStorage.sol";
import "./components/Freezable.sol";

contract ZkPay is MainStorage, Freezable {
    using Addresses for address;

    modifier onlyOperator() {
        require(operators[msg.sender], "ONLY_OPERATOR");
        _;
    }

    struct Modification {
        uint32 accountId;
        uint32 assetId;
        int64 biasedDelta;
    }

    event LogStateUpdate(uint256 batchId, uint256 vaultRoot);

    event LogDeposit(
        address depositorEthKey,
        uint32 accountId,
        uint32 assetId,
        uint64 quantizedAmount
    );

    event LogAssetWithdrawalAllowed(
        uint32 accountId,
        uint32 assetId,
        uint64 quantizedAmount
    );

    event LogWithdrawalPerformed(
        uint64 accountId,
        uint64 assetId,
        uint256 quantizedAmount,
        address recipient
    );

    /// fix to one token for demo
    constructor(
        address _tokenAddress,
        address _groth16VerifierAddress,
        address _operator
    ) {
        tokenAddress = _tokenAddress;
        groth16VerifierAddress = _groth16VerifierAddress;
        operators[_operator] = true;
    }

    /// @notice deposit ERC20 token
    /// @dev deposit
    /// @param ownerKey The L2 public key that corresponds to the vault ID.
    /// @param assetId The asset identifier of the token to be deposited.
    /// @param accountId The recipient’s off-chain account.
    /// @param quantizedAmount For ERC-20 and ERC-1155, the amount to be deposited.
    function depositERC20(
        uint256 ownerKey,
        uint32 assetId,
        uint32 accountId,
        uint64 quantizedAmount
    ) public {
        deposit(ownerKey, assetId, accountId, quantizedAmount);
    }

    /// @notice Transfers funds from the on-chain deposit area to the off-chain area.
    function acceptDeposit(
        uint32 accountId,
        uint32 assetId,
        uint64 quantizedAmount
    ) internal {
        // Fetch deposit.
        require(
            pendingDeposits[assetId][accountId] >= quantizedAmount,
            "DEPOSIT_INSUFFICIENT"
        );

        // Subtract accepted quantized amount.
        pendingDeposits[assetId][accountId] -= quantizedAmount;
    }

    function getDepositBalance(
        uint32 accountId,
        uint32 assetId
    ) external view returns (uint256) {
        return pendingDeposits[assetId][accountId];
    }

    /// @notice Verifier authorizes withdrawal.
    function acceptWithdrawal(
        uint32 accountId,
        uint32 assetId,
        uint64 quantizedAmount
    ) internal virtual {
        allowWithdrawal(accountId, assetId, quantizedAmount);
    }

    /// @notice Moves funds from the pending withdrawal account to the owner address.
    function withdraw(uint32 accountId, uint32 assetId) external {
        withdrawInternal(accountId, assetId);
    }

    function deposit(
        uint256 ownerKey,
        uint32 assetId,
        uint32 accountId,
        uint64 quantizedAmount
    ) public {
        require(accountId < 2 ** accountTreeHeight, "VAULT_ID_OUT_RANGE");

        // Updates the pendingDeposits balance and clears cancellationRequests when applicable.
        depositStateUpdate(ownerKey, assetId, accountId, quantizedAmount);

        // Transfer the tokens to the Deposit contract.
        transferIn(assetId, uint256(quantizedAmount));

        // Log event.
        emit LogDeposit(msg.sender, accountId, assetId, quantizedAmount);
    }

    function depositStateUpdate(
        uint256 ownerKey,
        uint32 assetId,
        uint32 accountId,
        uint64 quantizedAmount
    ) private returns (uint256) {
        // Checks for overflow and updates the pendingDeposits balance.
        uint64 vaultBalance = pendingDeposits[assetId][accountId];
        vaultBalance += quantizedAmount;
        require(vaultBalance >= quantizedAmount, "DEPOSIT_OVERFLOW");
        pendingDeposits[assetId][accountId] = vaultBalance;

        // Returns the updated vault balance.
        return vaultBalance;
    }

    /// @notice Transfers funds from the off-chain area to the on-chain withdrawal area.
    function allowWithdrawal(
        uint32 accountId,
        uint32 assetId,
        uint64 quantizedAmount
    ) internal {
        // Fetch withdrawal.
        uint64 withdrawal = pendingWithdrawals[assetId][accountId];

        // Add accepted quantized amount.
        withdrawal += quantizedAmount;
        require(withdrawal >= quantizedAmount, "WITHDRAWAL_OVERFLOW");

        // Store withdrawal.
        pendingWithdrawals[assetId][accountId] = withdrawal;

        emit LogAssetWithdrawalAllowed(accountId, assetId, quantizedAmount);
    }

    /// @notice update zk pay shared state
    function updateState(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[178] calldata _pubSignals,
        uint256[] calldata publicInput, // TODO: to be extracted from _pubSignals
        Modification[] calldata modifications
    ) external virtual notFrozen onlyOperator returns (bool) {
        require(publicInput.length >= 4, "incorrect publicInput length");
        require(
            IGroth16Verifier(groth16VerifierAddress).verifyProof(
                _pA,
                _pB,
                _pC,
                _pubSignals
            ),
            "groth16 verification fail"
        );

        rootUpdate(
            publicInput[PUB_IN_BATCHID_OFFSET],
            publicInput[PUB_IN_VALIDIUM_VAULT_ROOT_AFTER_OFFSET]
        );

        performModification(
            modifications,
            bytes32(publicInput[PUB_IN_MODIFICATION_HASH_OFFSET])
        );
        return true;
    }

    function rootUpdate(
        uint256 _batchId,
        uint256 newValidiumVaultRoot
    ) internal virtual {
        // Update state.
        validiumVaultRoot = newValidiumVaultRoot;
        batchId = _batchId;

        // Log update.
        emit LogStateUpdate(batchId, validiumVaultRoot);
    }

    function performModification(
        Modification[] memory modifications,
        bytes32 modificationHash
    ) public returns (bytes32 requestHash) {
        uint256 nModifications = modifications.length;

        bytes32 requestHash = hashModifications(modifications);
        require(requestHash == modificationHash, "modification hash not match");

        for (uint256 i = 0; i < nModifications; i++) {
            if (modifications[i].biasedDelta > 0) {
                acceptDeposit(
                    modifications[i].accountId,
                    modifications[i].assetId,
                    uint64(modifications[i].biasedDelta)
                );
            } else {
                acceptWithdrawal(
                    modifications[i].accountId,
                    modifications[i].assetId,
                    uint64(-modifications[i].biasedDelta)
                );
            }
        }
    }

    function modificationToUint256(
        Modification memory modification
    ) public pure returns (uint256) {
        uint256 result = uint256(modification.accountId);
        result = (result << 32) | uint256(modification.assetId);
        result = (result << 64) | uint256(uint64(modification.biasedDelta));
        return result;
    }

    function hashModifications(
        Modification[] memory modifications
    ) public pure returns (bytes32) {
        uint256 nModifications = modifications.length;

        uint256[] memory mod_hashs = new uint256[](nModifications);
        for (uint i = 0; i < nModifications; i++) {
            mod_hashs[i] = modificationToUint256(modifications[i]);
        }
        bytes memory result = abi.encodePacked(mod_hashs);

        bytes32 requestHash = keccak256(result);
        return requestHash;
    }

    /// @notice Transfers funds from msg.sender to the exchange.
    function transferIn(uint256 assetId, uint256 quantizedAmount) internal {
        if (quantizedAmount == 0) return;
        IERC20 token = IERC20(tokenAddress);
        uint256 exchangeBalanceBefore = token.balanceOf(address(this));
        bytes memory callData = abi.encodeWithSelector(
            token.transferFrom.selector,
            msg.sender,
            address(this),
            quantizedAmount
        );
        tokenAddress.safeTokenContractCall(callData);
        uint256 exchangeBalanceAfter = token.balanceOf(address(this));
        require(exchangeBalanceAfter >= exchangeBalanceBefore, "OVERFLOW");
        // NOLINTNEXTLINE(incorrect-equality): strict equality needed.
        require(
            exchangeBalanceAfter == exchangeBalanceBefore + quantizedAmount,
            "INCORRECT_AMOUNT_TRANSFERRED"
        );
    }

    /// @notice Transfers funds from the exchange to recipient.
    function transferOut(
        address recipient,
        uint256 assetId,
        uint256 quantizedAmount
    ) internal {
        // Make sure we don't accidentally burn funds.
        require(recipient != address(0x0), "INVALID_RECIPIENT");
        if (quantizedAmount == 0) return;
        IERC20 token = IERC20(tokenAddress);
        uint256 exchangeBalanceBefore = token.balanceOf(address(this));
        bytes memory callData = abi.encodeWithSelector(
            token.transfer.selector,
            recipient,
            quantizedAmount
        );
        tokenAddress.safeTokenContractCall(callData);
        uint256 exchangeBalanceAfter = token.balanceOf(address(this));
        require(exchangeBalanceAfter <= exchangeBalanceBefore, "UNDERFLOW");
        // NOLINTNEXTLINE(incorrect-equality): strict equality needed.
        require(
            exchangeBalanceAfter == exchangeBalanceBefore - quantizedAmount,
            "INCORRECT_AMOUNT_TRANSFERRED"
        );
    }

    // internal function
    function withdrawInternal(uint32 accountId, uint32 assetId) internal {
        address recipient = strictGetEthKey(accountId);
        // Fetch and clear quantized amount.
        uint256 quantizedAmount = pendingWithdrawals[accountId][assetId];
        pendingWithdrawals[accountId][assetId] = 0;

        // Transfer funds.
        transferOut(recipient, assetId, quantizedAmount);
        emit LogWithdrawalPerformed(
            accountId,
            assetId,
            quantizedAmount,
            recipient
        );
    }

    /// @notice Returns the Ethereum public key (address) that owns the given accountId.
    function getEthKey(uint32 accountId) public view returns (address) {
        address registeredEth = ethKeys[accountId];

        if (registeredEth != address(0x0)) {
            return registeredEth;
        }

        return address(0x0);
    }

    /// @notice Same as getEthKey, but fails when a jubjub key is not registered.
    function strictGetEthKey(
        uint32 accountId
    ) internal view returns (address ethKey) {
        ethKey = getEthKey(accountId);
        require(ethKey != address(0x0), "USER_UNREGISTERED");
    }
}
