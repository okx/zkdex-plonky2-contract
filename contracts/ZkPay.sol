// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.8.24;

import "./interfaces/IERC20.sol";
import "./libraries/Address.sol";
contract ZkPay {
    using Addresses for address;

    address tokenAddress;
    uint8 accountTreeHeight = 32; // NOLINT: constable-states uninitialized-state.

    // Pending deposits.
    // A map asset id => account id => quantized amount.
    mapping(uint256 => mapping(uint256 => uint256)) pendingDeposits;
    // Pending withdrawals.
    // A map asset id => account id => quantized amount.
    mapping(uint256 => mapping(uint256 => uint256)) pendingWithdrawals;

    // Mapping from accountId to the Ethereum public key of its owner.
    mapping(uint256 => address) ethKeys; // NOLINT: uninitialized-state.

    event LogDeposit(
        address depositorEthKey,
        uint256 accountId,
        uint256 assetId,
        uint256 quantizedAmount
    );

    event LogAssetWithdrawalAllowed(
        uint256 accountId,
        uint256 assetId,
        uint256 quantizedAmount
    );

    event LogWithdrawalPerformed(
        uint256 accountId,
        uint256 assetId,
        uint256 quantizedAmount,
        address recipient
    );

    /// fix to one token for demo
    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    /// @notice deposit ERC20 token
    /// @dev deposit
    /// @param ownerKey The L2 public key that corresponds to the vault ID.
    /// @param assetId The asset identifier of the token to be deposited.
    /// @param accountId The recipient’s off-chain account.
    /// @param quantizedAmount For ERC-20 and ERC-1155, the amount to be deposited.
    function depositERC20(
        uint256 ownerKey,
        uint256 assetId,
        uint256 accountId,
        uint256 quantizedAmount
    ) public {
        deposit(ownerKey, assetId, accountId, quantizedAmount);
    }

    /// @notice Transfers funds from the on-chain deposit area to the off-chain area.
    function acceptDeposit(
        uint256 ownerKey,
        uint256 accountId,
        uint256 assetId,
        uint256 quantizedAmount
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
        uint256 accountId,
        uint256 assetId
    ) external view returns (uint256) {
        return pendingDeposits[assetId][accountId];
    }

    /// @notice Verifier authorizes withdrawal.
    function acceptWithdrawal(
        uint256 accountId,
        uint256 assetId,
        uint256 quantizedAmount
    ) internal virtual {
        allowWithdrawal(accountId, assetId, quantizedAmount);
    }

    /// @notice Moves funds from the pending withdrawal account to the owner address.
    function withdraw(uint256 accountId, uint256 assetId) external {
        withdrawInternal(accountId, assetId);
    }

    function deposit(
        uint256 ownerKey,
        uint256 assetId,
        uint256 accountId,
        uint256 quantizedAmount
    ) public {
        require(accountId < 2 ** accountTreeHeight, "VAULT_ID_OUT_RANGE");

        // Updates the pendingDeposits balance and clears cancellationRequests when applicable.
        depositStateUpdate(ownerKey, assetId, accountId, quantizedAmount);

        // Transfer the tokens to the Deposit contract.
        transferIn(assetId, quantizedAmount);

        // Log event.
        emit LogDeposit(msg.sender, accountId, assetId, quantizedAmount);
    }

    function depositStateUpdate(
        uint256 ownerKey,
        uint256 assetId,
        uint256 accountId,
        uint256 quantizedAmount
    ) private returns (uint256) {
        // Checks for overflow and updates the pendingDeposits balance.
        uint256 vaultBalance = pendingDeposits[assetId][accountId];
        vaultBalance += quantizedAmount;
        require(vaultBalance >= quantizedAmount, "DEPOSIT_OVERFLOW");
        pendingDeposits[assetId][accountId] = vaultBalance;

        // Returns the updated vault balance.
        return vaultBalance;
    }

    /// @notice Transfers funds from the off-chain area to the on-chain withdrawal area.
    function allowWithdrawal(
        uint256 accountId,
        uint256 assetId,
        uint256 quantizedAmount
    ) internal {
        // Fetch withdrawal.
        uint256 withdrawal = pendingWithdrawals[assetId][accountId];

        // Add accepted quantized amount.
        withdrawal += quantizedAmount;
        require(withdrawal >= quantizedAmount, "WITHDRAWAL_OVERFLOW");

        // Store withdrawal.
        pendingWithdrawals[assetId][accountId] = withdrawal;

        emit LogAssetWithdrawalAllowed(accountId, assetId, quantizedAmount);
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
    function withdrawInternal(uint256 accountId, uint256 assetId) internal {
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
    function getEthKey(uint256 accountId) public view returns (address) {
        address registeredEth = ethKeys[accountId];

        if (registeredEth != address(0x0)) {
            return registeredEth;
        }

        return address(0x0);
    }

    /// @notice Same as getEthKey, but fails when a jubjub key is not registered.
    function strictGetEthKey(
        uint256 accountId
    ) internal view returns (address ethKey) {
        ethKey = getEthKey(accountId);
        require(ethKey != address(0x0), "USER_UNREGISTERED");
    }
}
