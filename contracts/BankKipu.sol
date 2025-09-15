// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title KipuBank
 * @author Ernesto de Oliveira
 * @notice Secure decentralized bank with individual vaults, global deposit limit and withdrawal controls
 * @dev Implements CEI pattern, custom errors, modifiers and secure transfers
 */
contract KipuBank {
    /*//////////////////////////////////////////////////////////////
                            IMMUTABLE VARIABLES
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Maximum withdrawal limit per transaction
    /// @dev Set at deployment and immutable
    uint256 public immutable WITHDRAWAL_LIMIT;
    
    /// @notice Maximum total bank capacity
    /// @dev Global deposit limit
    uint256 public immutable BANK_CAP;

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Total ETH deposited in the bank
    uint256 public totalDeposits;
    
    /// @notice Total deposit counter
    uint256 public depositCount;
    
    /// @notice Total withdrawal counter
    uint256 public withdrawalCount;

    /*//////////////////////////////////////////////////////////////
                                MAPPINGS
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Individual balances per user
    mapping(address => uint256) private s_balances;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Emitted when a deposit is made
    /// @param user User address
    /// @param amount Deposited amount
    /// @param newBalance User's new balance
    event Deposit(address indexed user, uint256 amount, uint256 newBalance);
    
    /// @notice Emitted when a withdrawal is made
    /// @param user User address
    /// @param amount Withdrawn amount
    /// @param newBalance User's remaining balance
    event Withdrawal(address indexed user, uint256 amount, uint256 newBalance);

    /*//////////////////////////////////////////////////////////////
                            CUSTOM ERRORS
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Sent value is zero
    error NoValueSent();
    
    /// @notice Deposit would exceed bank capacity
    /// @param attempted Attempted value
    /// @param available Available capacity
    error ExceedsBankCap(uint256 attempted, uint256 available);
    
    /// @notice Withdrawal exceeds per-transaction limit
    /// @param requested Requested value
    /// @param limit Maximum limit
    error ExceedsWithdrawalLimit(uint256 requested, uint256 limit);
    
    /// @notice Insufficient balance
    /// @param requested Requested value
    /// @param available Available balance
    error InsufficientBalance(uint256 requested, uint256 available);
    
    /// @notice Transfer failed
    error TransferFailed();

    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Initializes the KipuBank contract
     * @param _bankCap Maximum bank capacity
     * @param _withdrawalLimit Maximum limit per withdrawal
     */
    constructor(uint256 _bankCap, uint256 _withdrawalLimit) {
        BANK_CAP = _bankCap;
        WITHDRAWAL_LIMIT = _withdrawalLimit;
    }

    /*//////////////////////////////////////////////////////////////
                              MODIFIERS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Validates that deposit does not exceed capacity
     * @param amount Deposit amount
     */
    modifier withinBankCap(uint256 amount) {
        uint256 availableCapacity = BANK_CAP - totalDeposits;
        if (amount > availableCapacity) {
            revert ExceedsBankCap(amount, availableCapacity);
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                        EXTERNAL PAYABLE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Allows depositing ETH to personal vault
     * @dev Follows Checks-Effects-Interactions pattern
     */
    function deposit() 
        external 
        payable 
        withinBankCap(msg.value)
    {
        // Checks
        if (msg.value == 0) revert NoValueSent();

        // Effects
        s_balances[msg.sender] += msg.value;
        totalDeposits += msg.value;
        _updateCounters(true);

        // Interactions (events only)
        emit Deposit(msg.sender, msg.value, s_balances[msg.sender]);
    }

    /*//////////////////////////////////////////////////////////////
                        EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Allows withdrawing ETH from personal vault
     * @param _amount Amount to withdraw
     * @dev Implements CEI pattern
     */
    function withdraw(uint256 _amount) external {
        // Checks
        if (_amount == 0) revert NoValueSent();
        if (_amount > WITHDRAWAL_LIMIT) {
            revert ExceedsWithdrawalLimit(_amount, WITHDRAWAL_LIMIT);
        }
        if (s_balances[msg.sender] < _amount) {
            revert InsufficientBalance(_amount, s_balances[msg.sender]);
        }

        // Effects
        s_balances[msg.sender] -= _amount;
        totalDeposits -= _amount;
        _updateCounters(false);

        // Interactions
        emit Withdrawal(msg.sender, _amount, s_balances[msg.sender]);
        
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        if (!success) revert TransferFailed();
    }

    /*//////////////////////////////////////////////////////////////
                            PRIVATE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Updates global counters
     * @param isDeposit True for deposit, false for withdrawal
     */
    function _updateCounters(bool isDeposit) private {
        if (isDeposit) {
            depositCount++;
        } else {
            withdrawalCount++;
        }
    }

    /*//////////////////////////////////////////////////////////////
                        EXTERNAL VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
     * @notice Returns user balance
     * @param user User address
     * @return Balance in wei
     */
    function getUserBalance(address user) external view returns (uint256) {
        return s_balances[user];
    }
}