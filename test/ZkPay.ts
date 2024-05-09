import {
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";
import { BigNumber } from 'bignumber.js'

describe("ZkPay", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployZkPayFixture() {

    // Contracts are deployed using the first signer/account by default
    const [deployer, otherAccount] = await hre.ethers.getSigners();
    const UsdcFactory = await hre.ethers.getContractFactory("TestERC20");
    const ZkPayFactory = await hre.ethers.getContractFactory("ZkPay");

    const usdc = await UsdcFactory.deploy(new BigNumber(1e+18).toString(10));
    const zkpay = await ZkPayFactory.deploy(usdc.getAddress());
    return { usdc, zkpay, deployer, otherAccount };
  }



  describe("deposit", function () {
    it("Should deposit", async function () {
      const { usdc, zkpay, deployer } = await loadFixture(deployZkPayFixture);
      const totalSupply = await usdc.totalSupply();
      expect(totalSupply).to.equal(1000000000000000000n);
      let zkpayAddress = await zkpay.getAddress();
      await usdc.connect(deployer).approve(zkpayAddress,2_000_000 );
      await zkpay.depositERC20(0,1,1,1_000_000);
      let depositAmt = await zkpay.getDepositBalance(1,1);
      expect(depositAmt).to.equal(1_000_000n)
    });

  });
});
