// Custom Exception Classes
class AccountNotFoundException implements Exception {
  final String message;
  AccountNotFoundException(this.message);
  @override
  String toString() => "AccountNotFoundException: $message";
}

class InsufficientFundsException implements Exception {
  final String message;
  InsufficientFundsException(this.message);
  @override
  String toString() => "InsufficientFundsException: $message";
}

class MinimumBalanceException implements Exception {
  final String message;
  MinimumBalanceException(this.message);
  @override
  String toString() => "MinimumBalanceException: $message";
}

// Abstract BankAccount Class
abstract class BankAccount {
  final int _accountNumber;
  final String _accountHolder;
  double _balance;

  BankAccount(this._accountNumber, this._accountHolder, this._balance);

  int get getAccountNumber => _accountNumber;
  String get getAccountHolder => _accountHolder;
  double get getBalance => _balance;

  void deposit(double amount);
  void withdraw(double amount);
  void displayAccountDetails();
}

// Interface for accounts that earn interest
abstract class InterestBearing {
  void calculateInterest();
}

// SavingsAccount Class
class SavingsAccount extends BankAccount implements InterestBearing {
  final double _minBalance = 500.0;
  final double _interestRate = 0.02;
  int _withdrawCount = 0;
  final int _withdrawLimit = 3;

  SavingsAccount(int accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError("Deposit amount must be positive.");
    _balance += amount;
    print(
      "Deposited \$${amount} to ${_accountHolder}. New balance: \$${_balance}",
    );
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError("Withdrawal amount must be positive.");
    if (_withdrawCount >= _withdrawLimit) {
      throw Exception("Withdrawal limit of $_withdrawLimit reached.");
    }
    if (_balance - amount < _minBalance) {
      throw MinimumBalanceException(
        "Cannot withdraw \$${amount}. Must maintain at least \$$_minBalance.",
      );
    }
    _balance -= amount;
    _withdrawCount++;
    print(
      "Withdrawn \$${amount} from ${_accountHolder}. Remaining balance: \$${_balance}",
    );
  }

  @override
  void calculateInterest() {
    double interest = _balance * _interestRate;
    _balance += interest;
    print("Interest added: \$${interest}. New balance: \$${_balance}");
  }

  @override
  void displayAccountDetails() {
    print("\nSavings Account Details:");
    print("Account No: $_accountNumber");
    print("Holder: $_accountHolder");
    print("Balance: \$$_balance");
  }
}

// CheckingAccount Class
class CheckingAccount extends BankAccount {
  final double _overdraftLimit = 200.0;
  final double _overdraftFee = 35.0;

  CheckingAccount(int accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError("Deposit amount must be positive.");
    _balance += amount;
    print(
      "Deposited \$${amount} to ${_accountHolder}. New balance: \$${_balance}",
    );
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError("Withdrawal amount must be positive.");
    if (_balance - amount < -_overdraftLimit) {
      throw InsufficientFundsException(
        "Overdraft limit exceeded (\$$_overdraftLimit). Withdrawal denied.",
      );
    }
    _balance -= amount;
    if (_balance < 0) {
      _balance -= _overdraftFee;
      print(
        "Overdraft! Fee of \$$_overdraftFee applied. New balance: \$$_balance",
      );
    } else {
      print(
        "Withdrawn \$${amount} from ${_accountHolder}. Remaining balance: \$${_balance}",
      );
    }
  }

  @override
  void displayAccountDetails() {
    print("\nChecking Account Details:");
    print("Account No: $_accountNumber");
    print("Holder: $_accountHolder");
    print("Balance: \$$_balance");
  }
}

// PremiumAccount Class
class PremiumAccount extends BankAccount implements InterestBearing {
  final double _minBalance = 10000.0;
  final double _interestRate = 0.05;

  PremiumAccount(int accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) throw ArgumentError("Deposit amount must be positive.");
    _balance += amount;
    print(
      "Deposited \$${amount} to ${_accountHolder}. New balance: \$${_balance}",
    );
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) throw ArgumentError("Withdrawal amount must be positive.");
    if (_balance - amount < _minBalance) {
      throw MinimumBalanceException(
        "Cannot withdraw \$${amount}. Must maintain minimum balance of \$$_minBalance.",
      );
    }
    _balance -= amount;
    print(
      "Withdrawn \$${amount} from ${_accountHolder}. Remaining balance: \$${_balance}",
    );
  }

  @override
  void calculateInterest() {
    double interest = _balance * _interestRate;
    _balance += interest;
    print("Interest added: \$${interest}. New balance: \$${_balance}");
  }

  @override
  void displayAccountDetails() {
    print("\nPremium Account Details:");
    print("Account No: $_accountNumber");
    print("Holder: $_accountHolder");
    print("Balance: \$$_balance");
  }
}

// Bank Class
class Bank {
  final List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
    print("Account created successfully for ${account.getAccountHolder}.");
  }

  BankAccount findAccount(int accountNumber) {
    try {
      return _accounts.firstWhere(
        (acc) => acc.getAccountNumber == accountNumber,
        orElse: () => throw AccountNotFoundException(
          "Account number $accountNumber not found.",
        ),
      );
    } catch (e) {
      throw AccountNotFoundException(
        "Account number $accountNumber not found.",
      );
    }
  }

  void deposit(int accountNumber, double amount) {
    var account = findAccount(accountNumber);
    account.deposit(amount);
  }

  void withdraw(int accountNumber, double amount) {
    var account = findAccount(accountNumber);
    account.withdraw(amount);
  }

  void transfer(int fromAccNo, int toAccNo, double amount) {
    var from = findAccount(fromAccNo);
    var to = findAccount(toAccNo);

    from.withdraw(amount);
    to.deposit(amount);

    print("Transferred \$${amount} from account $fromAccNo to $toAccNo");
  }

  void displayAllAccounts() {
    print("\nAll Accounts Summary:");
    for (var acc in _accounts) {
      acc.displayAccountDetails();
    }
  }
}

// Main Program
void main() {
  var bank = Bank();

  var acc1 = SavingsAccount(101, "Amit", 1000);
  var acc2 = CheckingAccount(102, "Aryan", 300);
  var acc3 = PremiumAccount(103, "Ishan", 15000);

  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);

  try {
    bank.deposit(101, 500);
    bank.withdraw(102, 100);
    acc1.calculateInterest();
    acc3.calculateInterest();

    bank.transfer(101, 103, 200);

    // Intentional error cases
    bank.withdraw(101, 2000); // Below minimum balance
  } catch (e) {
    print("Error: $e");
  }

  bank.displayAllAccounts();
}
