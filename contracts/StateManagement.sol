// SPDX-License-Identifier: Apache-2.0.
pragma solidity ^0.8.24;

import "./interfaces/IERC20.sol";
import "./libraries/Address.sol";
import "./components/MainStorage.sol";
import "./components/Freezable.sol";
import "./Groth16Verifier.sol";

contract StateManagement is MainStorage, Freezable, Groth16Verifier {
    modifier onlyOperator() {
        require(operators[msg.sender], "ONLY_OPERATOR");
        _;
    }

    event LogStateUpdate(
        uint256 batchId,
        uint256 vaultRoot
    );

    function updateState(
        uint[2] calldata _pA,
        uint[2][2] calldata _pB,
        uint[2] calldata _pC,
        uint[196] calldata _pubSignals,
        uint256[] calldata publicInput // TODO: to be extracted from _pubSignals
    ) external virtual notFrozen onlyOperator {
        require(publicInput.length >=3, "incorrect publicInput length");
        // updateStateInternal(publicInput, applicationData, false);
        require(verifyProof(_pA, _pB, _pC, _pubSignals), "groth16 verification fail");

        rootUpdate(publicInput[PUB_IN_BATCHID_OFFSET], publicInput[PUB_IN_VALIDIUM_VAULT_ROOT_AFTER_OFFSET]);

        // TODO: perform modification
    }

     function rootUpdate(
        uint256 _batchId,
        uint256 newValidiumVaultRoot
    ) internal virtual {


        // Update state.
        validiumVaultRoot = newValidiumVaultRoot;
        batchId = _batchId;

        // Log update.
        emit LogStateUpdate(
            batchId,
            validiumVaultRoot
        );
    }
}
