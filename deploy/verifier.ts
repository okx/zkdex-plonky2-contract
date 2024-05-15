import { Wallet, utils } from "zksync-web3";
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy";
import {TOKEN_ADDRS, DEFI_CONTRACT_ADDR_MAP} from '@meta/address';
import {DexExchange, Network, TOKEN} from '@meta/common';

// An example of a deploy script that will deploy and call a simple contract.
export default async function (hre: HardhatRuntimeEnvironment) {
    console.log(`Running deploy script for the AtomicSwapRouter contract`);

    console.log(hre.network)
    const network = hre.network.name as Network;
    if (!process.env.PRIVATE_KEY) {
        throw new Error('must provide process.env.PRIVATE_KEY')
    }

    // if (!process.env.EXECUTOR_ADDR) {
    //     throw new Error('must provide process.env.EXECUTOR_ADDR')
    // }
    // Initialize the wallet.
    const pk = process.env.PRIVATE_KEY || '';
    const wallet = new Wallet(pk);

    // const executor_addr = process.env.EXECUTOR_ADDR;
    // const weth_addr = TOKEN_ADDRS[network][TOKEN.WETH];
    // if(!weth_addr) {
    //     throw new Error('no weth address')
    // }


    // Create deployer object and load the artifact of the contract you want to deploy.
    const deployer = new Deployer(hre, wallet);
    const artifact = await deployer.loadArtifact("SyncSwapRouter");

    // Estimate contract deployment fee
    
    
    //   const deploymentFee = await deployer.estimateDeployFee(artifact, [executor_addr, weth_addr]);
    //   console.log('after estiamte deploymentFee')
    // OPTIONAL: Deposit funds to L2
    // Comment this block if you already have funds on zkSync.
    //   const depositHandle = await deployer.zkWallet.deposit({
    //     to: deployer.zkWallet.address,
    //     token: utils.ETH_ADDRESS,
    //     amount: deploymentFee.mul(2),
    //   });
    // Wait until the deposit is processed on zkSync
    //   await depositHandle.wait();

    // Deploy this contract. The returned object will be of a `Contract` type, similarly to ones in `ethers`.
    // `greeting` is an argument for contract constructor.
    //   const parsedFee = ethers.utils.formatEther(deploymentFee.toString());
    //   console.log(`The deployment is estimated to cost ${parsedFee} ETH`);

    const syncswapRouterContract = await deployer.deploy(artifact, ["0x621425a1Ef6abE91058E9712575dcc4258F8d091", "0x5aea5775959fbc2557cc8789bc1bf90a239d9a91"]);

    //obtain the Constructor Arguments
    console.log("constructor args:" + syncswapRouterContract.interface.encodeDeploy(["0x621425a1Ef6abE91058E9712575dcc4258F8d091", "0x5aea5775959fbc2557cc8789bc1bf90a239d9a91"]));

    // Show the contract info.
    const contractAddress = syncswapRouterContract.address;
    console.log(`${artifact.contractName} was deployed to ${contractAddress}`);
}