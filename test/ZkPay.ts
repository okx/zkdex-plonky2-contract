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
    const zkpay = await ZkPayFactory.deploy(usdc.getAddress(), verifier.getAddress());
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



      let coder = new ethers.AbiCoder();
      let result = coder.encode(["tuple(uint64, int128)[]"], [[[1, 100], [2, -200]]])


      let js_hash = ethers.keccak256(result);
      console.log('js_hash', js_hash);

      await zkpay.performModification([
        {
          accountId: 1,
          assetId: 1,
          biasedDelta: 100
        },
        {
          accountId: 2,
          assetId: 1,
          biasedDelta: -200
        }
      ], js_hash);


      //  let state_hash = await sm.state_hash();
      //  console.log('state_hash', state_hash);

    });
  });

});


