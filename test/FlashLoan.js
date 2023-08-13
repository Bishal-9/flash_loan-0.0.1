const hre = require("hardhat")
const { expect } = require("chai")

describe("Flash Loan", function () {
    let deployer
    let flashLoanContract
    const WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
    const AMOUNT = hre.ethers.parseUnits("10000", "ether")

    beforeEach(async () => {
        [deployer] = await hre.ethers.getSigners()

        flashLoanContract = await hre.ethers.deployContract("FlashLoan")
    })

    describe("Performing Flash Loan...", () => {
        it("Borrows 10000 WETH", async () => {
            expect(
                await flashLoanContract
                    .connect(deployer)
                    .getFlashLoan(WETH, AMOUNT)
            )
                .to.emit(flashLoanContract, "FlashLoan")
                .withArgs(WETH, AMOUNT)
        })
    })
})
