# zkdex-plonky2-contract

## test
```
npx hardhat test --grep "modification"
anvil
npx hardhat ignition deploy ./ignition/modules/Groth16Verifier.ts --network anvil
npx hardhat ignition deploy ./ignition/modules/ZkPay.ts --network anvil
```