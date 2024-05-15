import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import TokenModule from "./Token";
import VerifierModule from "./Groth16Verifier";



const ZkPayModule = buildModule("ZkPayModule", (m) => {

    const { token } = m.useModule(TokenModule);
    const { verifier } = m.useModule(VerifierModule);
 
    const zkpay = m.contract("ZkPay", [token, verifier, "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"], {
    });

    return { zkpay };
});

export default ZkPayModule;