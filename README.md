# ERC-20 Token Vault

A minimal educational Solidity contract for depositing and withdrawing one ERC-20 asset. The vault keeps an internal balance for each depositor and exposes deposit/withdraw events.

This repository is a learning project for Solidity, token interactions, per-user accounting, and basic reentrancy protection.

## Contract overview

The main contract is `TokenVault` in `src/TokenVault.sol`.

- **Single asset:** the token address is set once in the constructor and stored as an immutable reference.
- **Per-user accounting:** `balances` tracks each account's recorded deposit balance.
- **Deposit:** calls `transferFrom` to move tokens into the vault, then credits the caller's internal balance.
- **Withdraw:** checks the caller's recorded balance, debits it, then transfers tokens back.
- **Reentrancy guard:** both external state-changing functions use a simple `nonReentrant` modifier.
- **Events:** emits `Deposited` and `Withdrawn` for off-chain tracking.

## Requirements

- [Foundry](https://book.getfoundry.sh/) (Forge)
- Solidity compiler 0.8.24, as configured in `foundry.toml`

## Build

Clone the repository:

```bash
git clone https://github.com/cbt0116/erc20-token-vault.git
cd erc20-token-vault
```

Compile the contract:

```bash
forge build
```

## Tests

Run the Foundry test command:

```bash
forge test
```

**Current test status:** this repository does not yet contain an implemented Foundry test contract. The `test/README.md` lists suggested cases. A passing test suite should be added before treating the implementation as verified.

Recommended test coverage:

- Successful deposit and balance credit
- Successful withdrawal and balance debit
- Revert on zero-value deposits and withdrawals
- Revert when withdrawing more than the recorded balance
- Revert when the ERC-20 transfer operation returns `false`
- Reentrancy attempts using a malicious mock token
- Constructor rejection of the zero address

## Important design assumptions

- The vault assumes a conventional ERC-20 token whose `transfer` and `transferFrom` functions return a boolean.
- It credits the requested deposit amount. Fee-on-transfer and rebasing tokens are not supported by this accounting model.
- The contract does not include owner controls, pausing, rescue functions, or multi-asset support.
- The constructor checks that the asset address is nonzero, but does not verify that the address contains contract code.

## Security notice

This is an educational example, **not an audited or production-ready custody contract**. Do not deposit real funds. Smart-contract security requires comprehensive tests, review of token compatibility, and independent auditing before any production use.

## Potential improvements

- Use OpenZeppelin's `SafeERC20` for broader ERC-20 compatibility
- Add a complete Foundry test suite with mock and adversarial tokens
- Consider balance-delta accounting if supporting fee-on-transfer tokens
- Add fuzz and invariant tests for deposit/withdraw accounting
- Add static analysis and automated CI checks

## License

The Solidity source declares the MIT SPDX identifier. Add a repository-level LICENSE file to make the project license explicit to users browsing the repository.
