// Abstract base class
abstract class BankAccount {
  final int _accountNumber;
  final String _accountHolder;
  double _balance;
  final List<String> _transactionHistory = []; // Transaction history

  BankAccount(this._accountNumber, this._accountHolder, this._balance);

  int get getAccountNumber => _accountNumber;
  String get getAccountHolder => _accountHolder;
  double get getBalance => _balance;
  List<String> get getTransactionHistory => _transactionHistory;

  void deposit(double amount);
  void withdraw(double amount);
  void displayAccountDetails();

  // Helper method to record transactions
  void addTransaction(String entry) {
    _transactionHistory.add(entry);
  }
}

// Interface for interest-bearing accounts
abstract class InterestBearing {
  void calculateInterest();
}

// SavingsAccount
class SavingsAccount extends BankAccount implements InterestBearing {
  final double _minBalance = 500.0;
  final double _interestRate = 0.02;
  int _withdrawCount = 0;
  final int _withdrawLimit = 3;

  SavingsAccount(int accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) return;
    _balance += amount;
    addTransaction("Deposited \$${amount}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) return;
    if (_withdrawCount >= _withdrawLimit) return;
    if (_balance - amount < _minBalance) return;
    _balance -= amount;
    _withdrawCount++;
    addTransaction("Withdrawn \$${amount}");
  }

  @override
  void calculateInterest() {
    double interest = _balance * _interestRate;
    _balance += interest;
    addTransaction("Interest added: \$${interest}");
  }

  @override
  void displayAccountDetails() {
    print("\nSavings Account: $_accountHolder");
    print("Balance: \$$_balance");
    print("Transactions: $_transactionHistory");
  }
}

// CheckingAccount
class CheckingAccount extends BankAccount {
  final double _overdraftLimit = 200.0;
  final double _overdraftFee = 35.0;

  CheckingAccount(int accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) return;
    _balance += amount;
    addTransaction("Deposited \$${amount}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) return;
    if (_balance - amount < -_overdraftLimit) return;
    _balance -= amount;
    if (_balance < 0) _balance -= _overdraftFee;
    addTransaction("Withdrawn \$${amount}");
  }

  @override
  void displayAccountDetails() {
    print("\nChecking Account: $_accountHolder");
    print("Balance: \$$_balance");
    print("Transactions: $_transactionHistory");
  }
}

// PremiumAccount
class PremiumAccount extends BankAccount implements InterestBearing {
  final double _minBalance = 10000.0;
  final double _interestRate = 0.05;

  PremiumAccount(int accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) return;
    _balance += amount;
    addTransaction("Deposited \$${amount}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) return;
    if (_balance - amount < _minBalance) return;
    _balance -= amount;
    addTransaction("Withdrawn \$${amount}");
  }

  @override
  void calculateInterest() {
    double interest = _balance * _interestRate;
    _balance += interest;
    addTransaction("Interest added: \$${interest}");
  }

  @override
  void displayAccountDetails() {
    print("\nPremium Account: $_accountHolder");
    print("Balance: \$$_balance");
    print("Transactions: $_transactionHistory");
  }
}

// StudentAccount
class StudentAccount extends BankAccount {
  final double _maxBalance = 5000.0;

  StudentAccount(int accNo, String holder, double balance)
    : super(accNo, holder, balance);

  @override
  void deposit(double amount) {
    if (amount <= 0) return;
    if (_balance + amount > _maxBalance) {
      print("Deposit exceeds max balance of \$$_maxBalance.");
      return;
    }
    _balance += amount;
    addTransaction("Deposited \$${amount}");
  }

  @override
  void withdraw(double amount) {
    if (amount <= 0) return;
    if (_balance - amount < 0) {
      print("Insufficient funds.");
      return;
    }
    _balance -= amount;
    addTransaction("Withdrawn \$${amount}");
  }

  @override
  void displayAccountDetails() {
    print("\nStudent Account: $_accountHolder");
    print("Balance: \$$_balance");
    print("Transactions: $_transactionHistory");
  }
}

// Bank class
class Bank {
  final List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
  }

  BankAccount? findAccount(int accountNumber) {
    for (var acc in _accounts) {
      if (acc.getAccountNumber == accountNumber) return acc;
    }
    return null;
  }

  void transfer(int fromAccNo, int toAccNo, double amount) {
    var from = findAccount(fromAccNo);
    var to = findAccount(toAccNo);
    if (from == null || to == null) return;
    from.withdraw(amount);
    to.deposit(amount);
    from.addTransaction(
      "Transferred \$${amount} to account ${to.getAccountNumber}",
    );
    to.addTransaction(
      "Received \$${amount} from account ${from.getAccountNumber}",
    );
  }

  // Apply monthly interest to all interest-bearing accounts
  void applyMonthlyInterest() {
    for (var acc in _accounts) {
      if (acc is InterestBearing) {
        (acc as InterestBearing).calculateInterest();
      }
    }
  }

  void displayAllAccounts() {
    for (var acc in _accounts) {
      acc.displayAccountDetails();
    }
  }
}

// Main program
void main() {
  var bank = Bank();

  var acc1 = SavingsAccount(101, "Amit", 1000);
  var acc2 = CheckingAccount(102, "Aryan", 300);
  var acc3 = PremiumAccount(103, "Ishan", 15000);
  var acc4 = StudentAccount(104, "Neha", 2000);

  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);
  bank.createAccount(acc4);

  acc1.deposit(500);
  acc2.withdraw(100);
  acc4.deposit(3000); // Should warn if exceeds max balance
  bank.applyMonthlyInterest();
  bank.transfer(101, 104, 200);

  bank.displayAllAccounts();
}
