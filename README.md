# ERC-20 Token Vault

A minimal educational Solidity vault for ERC-20 deposits and withdrawals.

## Run
Install Foundry, then:
```bash
forge build
forge test
```

## Design notes
- Per-account accounting.
- Zero-amount and insufficient-balance checks.
- State updated before outbound token transfer.
- Assumes a conventional ERC-20 token; fee-on-transfer and rebasing assets require additional accounting.
- This is not audited and is not suitable for custody of production funds.
