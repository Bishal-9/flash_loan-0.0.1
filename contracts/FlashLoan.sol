// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.8;

// Uncomment this line to use console.log
import "hardhat/console.sol";
import "@balancer-labs/v2-interfaces/contracts/vault/IVault.sol";
import "@balancer-labs/v2-interfaces/contracts/vault/IFlashLoanRecipient.sol";

contract FlashLoan is IFlashLoanRecipient {
    IVault private constant vault =
        IVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);

    function getFlashLoan(address flashToken, uint256 flashAmount) external {
        uint256 balanceBefore = IERC20(flashToken).balanceOf(address(this));
        console.log("Balance before ", balanceBefore);
        bytes memory data = abi.encode(flashToken, flashAmount, balanceBefore);

        IERC20[] memory tokens = new IERC20[](1);
        tokens[0] = IERC20(flashToken);

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = flashAmount;

        vault.flashLoan(this, tokens, amounts, data);
    }

    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external {
        require(msg.sender == address(vault), "Sender is not Balancer Vault.");

        (address flashToken, uint256 flashAmount, uint256 balanceBefore) = abi
            .decode(userData, (address, uint256, uint256));

        uint256 balanceAfter = IERC20(flashToken).balanceOf(address(this));

        console.log("Balance Before: ", balanceBefore);
        console.log("Balance After: ", balanceAfter);

        require(
            balanceAfter - balanceBefore == flashAmount,
            "Contract did not get loan."
        );

        IERC20(flashToken).transfer(
            address(vault),
            flashAmount + feeAmounts[0]
        );
    }
}
