# KipuBank Smart Contract

## 📋 Description

**KipuBank** is a secure decentralized banking smart contract built in Solidity that allows users to deposit and withdraw ETH safely. The contract implements individual vaults for each user with strict security controls and operational limits.

### 🔥 Key Features

- **Individual Vaults**: Each user has their own vault to store ETH
- **Global Limit**: Maximum total bank capacity set at deployment
- **Per-Transaction Limit**: Maximum amount that can be withdrawn per transaction
- **Advanced Security**: Implements CEI (Checks-Effects-Interactions) pattern
- **Fallback Functions**: Automatic deposit when ETH is sent directly to contract
- **Privacy Protection**: Users can only check their own balance
- **Detailed Events**: Complete tracking of all operations
- **Complete Metrics**: Global and per-user statistics

### 🛡️ Security Features

- ✅ Custom errors for gas efficiency
- ✅ Modifiers for input validation
- ✅ Reentrancy protection
- ✅ Secure ETH transfers with `call()`
- ✅ CEI pattern implementation
- ✅ Fallback and receive functions for direct ETH transfers
- ✅ Privacy-first balance queries

## 🚀 Deployment with Remix IDE

### Prerequisites

- MetaMask or compatible wallet
- ETH for deployment (testnet recommended for testing)
- Access to [Remix IDE](https://remix.ethereum.org/)

### Step-by-Step Deployment

1. **Open Remix IDE**
   - Go to [https://remix.ethereum.org/](https://remix.ethereum.org/)
   - Create a new file named `KipuBank.sol`
   - Copy and paste the contract code

2. **Compile the Contract**
   - Go to the "Solidity Compiler" tab
   - Select compiler version `0.8.19` or higher
   - Click "Compile KipuBank.sol"
   - Ensure compilation is successful (green checkmark)

3. **Deploy the Contract**
   - Go to the "Deploy & Run Transactions" tab
   - Select your environment (Injected Provider - MetaMask for mainnet/testnet)
   - Connect your MetaMask wallet
   - Select "KipuBank" from the contract dropdown

4. **Set Constructor Parameters**
   The contract requires two parameters:
   - `_BANKCAP`: Maximum total bank capacity in wei
   - `_WITHDRAWALLIMIT`: Maximum withdrawal per transaction in wei
   
   **Example values:**
   - For 100 ETH bank cap: `100000000000000000000`
   - For 1 ETH withdrawal limit: `1000000000000000000`
   
   **Converting ETH to Wei:**
   - 1 ETH = 1,000,000,000,000,000,000 wei (18 zeros)
   - Use online converters or: ETH amount × 10^18

5. **Deploy**
   - Enter the constructor parameters
   - Click "Deploy"
   - Confirm the transaction in MetaMask
   - Wait for deployment confirmation

## 🔧 Contract Interaction with Remix IDE

### 💰 Making Deposits

#### Method 1: Using deposit() function
1. **Locate the Contract**
   - After deployment, find your contract in the "Deployed Contracts" section
   - Expand the contract to see available functions

2. **Set Deposit Amount**
   - In the **VALUE** field at the top, enter the amount you want to deposit
   - Change the unit dropdown from "Wei" to **"Ether"**
   - Example: Enter `0.5` and select "Ether" to deposit 0.5 ETH

3. **Execute Deposit**
   - Click the orange **"deposit"** button
   - Confirm the transaction in MetaMask
   - Wait for transaction confirmation

#### Method 2: Direct ETH Transfer
- Simply send ETH directly to the contract address
- The fallback/receive functions will automatically process it as a deposit
- Same validations and limits apply

### 💸 Making Withdrawals

1. **Set Withdrawal Amount**
   - Find the **"withdraw"** function in your deployed contract
   - Enter the amount in **wei** in the input field
   - **Converting ETH to Wei:**
     - 0.1 ETH = `100000000000000000` wei
     - 0.5 ETH = `500000000000000000` wei
     - 1.0 ETH = `1000000000000000000` wei

2. **Execute Withdrawal**
   - Click the orange **"withdraw"** button
   - Confirm the transaction in MetaMask
   - ETH will be sent to your wallet

### 📊 Querying Contract State

#### Check Your Balance
1. Find the **"getMyBalance"** function
2. Click the blue **"getMyBalance"** button (no parameters needed)
3. Result shows your balance in wei

#### Check Remaining Bank Capacity
1. Find the **"getRemainingCapacity"** function
2. Click the blue **"getRemainingCapacity"** button
3. Result shows how much ETH can still be deposited (in wei)

#### Check Contract Statistics
- **"totalDeposits"**: Click to see total ETH deposited (in wei)
- **"depositCount"**: Click to see number of deposits made
- **"withdrawalCount"**: Click to see number of withdrawals made
- **"BANK_CAP"**: Click to see maximum bank capacity (in wei)
- **"WITHDRAWAL_LIMIT"**: Click to see withdrawal limit per transaction (in wei)
- **"getRemainingCapacity"**: Click to see remaining deposit capacity (in wei)

#### Converting Wei to ETH
- Divide the wei amount by 1,000,000,000,000,000,000 (18 zeros)
- Or use online wei-to-ETH converters

## 📋 Available Functions

### Public Functions

| Function | Type | Description |
|----------|------|-------------|
| `deposit()` | payable | Deposits ETH to personal vault |
| `withdraw(uint256)` | external | Withdraws ETH from personal vault |
| `getMyBalance()` | view | Returns caller's own balance |
| `getRemainingCapacity()` | view | Returns remaining deposit capacity |
| `fallback()` | payable | Handles direct ETH transfers |
| `receive()` | payable | Handles plain ETH transfers |

### Public Variables

| Variable | Type | Description |
|----------|------|-------------|
| `WITHDRAWAL_LIMIT` | immutable | Maximum withdrawal per transaction |
| `BANK_CAP` | immutable | Maximum total bank capacity |
| `totalDeposits` | uint256 | Total ETH deposited |
| `depositCount` | uint256 | Number of deposits made |
| `withdrawalCount` | uint256 | Number of withdrawals made |

### Events

| Event | Parameters | Description |
|-------|------------|-------------|
| `Deposit` | `user`, `amount`, `newBalance` | Emitted on deposits |
| `Withdrawal` | `user`, `amount`, `newBalance` | Emitted on withdrawals |

### Custom Errors

| Error | Description |
|-------|-------------|
| `NoValueSent()` | Sent value is zero |
| `ExceedsBankCap(uint256, uint256)` | Deposit exceeds capacity |
| `ExceedsWithdrawalLimit(uint256, uint256)` | Withdrawal exceeds limit |
| `InsufficientBalance(uint256, uint256)` | Insufficient balance |
| `TransferFailed()` | ETH transfer failed |

## 🔒 Rules and Limitations

### Deposits
- ✅ Any value > 0 (no minimum)
- ✅ Limited by remaining bank capacity
- ✅ Must send ETH with transaction

### Withdrawals
- ✅ Value must be > 0
- ✅ Cannot exceed user balance
- ✅ Cannot exceed per-transaction limit
- ✅ Must have sufficient balance

## 🧪 Testing in Remix IDE

### Manual Testing Steps

1. **Deploy with Test Parameters**
   - Bank Cap: `10000000000000000000` (10 ETH)
   - Withdrawal Limit: `1000000000000000000` (1 ETH)

2. **Test Deposits**
   - Set VALUE to `0.5` Ether and call `deposit()`
   - Check your balance with `getMyBalance()`
   - Verify `totalDeposits` increased
   - Verify `depositCount` increased
   - Test direct ETH transfer to contract address

3. **Test Withdrawals**
   - Try withdrawing `500000000000000000` wei (0.5 ETH)
   - Check your balance decreased with `getMyBalance()`
   - Verify `totalDeposits` decreased
   - Verify `withdrawalCount` increased
   - Check `getRemainingCapacity()` increased

4. **Test Limits**
   - Try withdrawing more than the limit (e.g., `1500000000000000000` wei)
   - Should fail with `ExceedsWithdrawalLimit` error
   - Try depositing more than `getRemainingCapacity()` shows
   - Should fail with `ExceedsBankCap` error
   - Test both direct transfer and deposit() function limits

5. **Test Edge Cases**
   - Try depositing 0 ETH (should fail with `NoValueSent`)
   - Try withdrawing more than your balance
   - Try withdrawing 0 (should fail with `NoValueSent`)

### Recommended Test Network
- Use **Sepolia** or **Goerli** testnet for testing
- Get test ETH from faucets:
  - [Sepolia Faucet](https://sepoliafaucet.com/)
  - [Goerli Faucet](https://goerlifaucet.com/)

## 📄 License

This project is licensed under the MIT License.

## ⚠️ Legal Disclaimer

This contract is provided "as is" for educational and demonstration purposes. Always conduct security audits before using in production with real funds.

## 🤝 Contributions

Contributions are welcome! Please open an issue or pull request for improvement suggestions.

---

**Built with ❤️ in Floripa, Brazil**
