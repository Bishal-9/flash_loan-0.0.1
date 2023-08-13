
const hre = require("hardhat")

async function main() {
  const flashLoan = await hre.ethers.deployContract("FlashLoan")
  await flashLoan.waitForDeployment()

  console.log(`Flash Loan Contract is deployed to ${await flashLoan.getAddress()}`)
}

main().catch(error => {
  console.error(error)
  process.exitCode = 1
})
