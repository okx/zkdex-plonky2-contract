import {ethers} from "hardhat";
import {
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import {assert, expect} from "chai";
import hre from "hardhat";
import * as path  from "path"

describe("Groth16Verifier", function () {

    async function deployVerifierFixture() {

        const verifierFactory = await hre.ethers.getContractFactory("Groth16Verifier");
        const verifier = await verifierFactory.deploy();
        return {verifier}
      }

    it("Should return true when proof is correct", async function () {
        const { verifier } = await loadFixture(deployVerifierFixture);
        const fs = require("fs");
        let text = fs.readFileSync(path.resolve(__dirname, "test_data/public.txt")).toString();
        text = text.replace(/\s+/g, '');
        text = text.replace(/\[+/g, '');
        text = text.replace(/]+/g, '');
        text = text.replace(/"+/g, '');
        const p = text.split(",");
        let public_inputs = [];
        for (let i = 0; i < p.length - 8; i++) {
            public_inputs.push(p[8 + i]);
        }
        expect(await verifier.verifyProof(
            [p[0], p[1]],
            [[p[2], p[3]], [p[4], p[5]]],
            [p[6], p[7]], public_inputs
        )).to.equal(true);
    });
});
