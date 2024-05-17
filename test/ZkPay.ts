import {
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";
import { BigNumber } from 'bignumber.js'
import { ethers } from 'ethers';

describe("zkpay", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployZkPayFixture() {

    // Contracts are deployed using the first signer/account by default
    const [deployer, otherAccount] = await hre.ethers.getSigners();
    const UsdcFactory = await hre.ethers.getContractFactory("TestERC20");
    const Groth16VerifierFactory = await hre.ethers.getContractFactory("Groth16Verifier");
    const ZkPayFactory = await hre.ethers.getContractFactory("ZkPay");

    const usdc = await UsdcFactory.deploy(new BigNumber(1e+18).toString(10));
    const verifier = await Groth16VerifierFactory.deploy();
    const zkpay = await ZkPayFactory.deploy(usdc.getAddress(), verifier.getAddress(), "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");
    return { usdc, zkpay, deployer, otherAccount };
  }

  describe("deposit", function () {
    it("Should deposit", async function () {
      const { usdc, zkpay, deployer } = await loadFixture(deployZkPayFixture);
      const totalSupply = await usdc.totalSupply();
      expect(totalSupply).to.equal(1000000000000000000n);
      let zkpayAddress = await zkpay.getAddress();
      await usdc.connect(deployer).approve(zkpayAddress, 2_000_000);
      await zkpay.depositERC20(0, 1, 1, 1_000_000);
      let depositAmt = await zkpay.getDepositBalance(1, 1);
      expect(depositAmt).to.equal(1_000_000n)
    });

    it("Should not deposit more than allowance", async function () {
      const { usdc, zkpay, deployer } = await loadFixture(deployZkPayFixture);

      let zkpayAddress = await zkpay.getAddress();
      await usdc.connect(deployer).approve(zkpayAddress, 2_000_000);
      let msg = await zkpay.depositERC20(0, 1, 1, 3_000_000).catch(e => e);
      // TODO: use expect().to.be.revertedWith();
      expect(msg.toString().includes('allowance insufficient')).to.be.true;
    })

  });

  describe("modification", function () {

    it("Should performModification", async function () {
      const { zkpay } = await loadFixture(deployZkPayFixture);

      // let ret_modificationToUint256 = await zkpay.modificationToUint256(
      //   {
      //     accountId: 3,
      //     assetId: 5,
      //     biasedDelta: -100
      //   },
      // );
      // console.log('ret_modificationToUint256', ret_modificationToUint256);


      let solidity_modification_hash = await zkpay.hashModifications(
        [
          {
            accountId: 3,
            assetId: 5,
            biasedDelta: 100
          },
          {
            accountId: 3,
            assetId: 5,
            biasedDelta: -100
          },
        ]
      );

      console.log(solidity_modification_hash);

      let bytes_empty_32 = '00000000000000000000000000000000';
      let buf = Buffer.from(`${bytes_empty_32}00000003000000050000000000000064${bytes_empty_32}0000000300000005ffffffffffffff9c`, "hex");
      let js_hash = ethers.keccak256(buf);
      console.log(js_hash);
      expect(solidity_modification_hash).to.equal(js_hash)

    });
  });

});
