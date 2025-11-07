// Bankinhg system in Dart using Four Pillars of OOPS

abstract class BankAccount {
  int _accountNumber;
  String _accountHolderName;
  double _balance;

  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  void withdraw(double amount);
  void deposit(double amount);

  void displayAccountinfo() {
    print(
      "A/c No: $_accountNumber \nAccount Holder: $_accountHolderName /Balance: $_balance",
    );
  }

  int get getAccountNumber {
    return _accountNumber;
  }

  set setAccountNumber(int accountNumber) {
    this._accountNumber = accountNumber;
  }

  String get getAccountHolder {
    return _accountHolderName;
  }

  set setAccountHolder(String accountHolder) {
    this._accountHolderName = accountHolder;
  }

  double get getBalance {
    return _balance;
  }

  set setBalance(double balance) {
    this._balance = balance;
  }
}

//Create an interface/abstract class InterestBearing for accounts that earn interest
abstract class InterestBearing {
  void calculateInterest();
}

class SavingsAccount extends BankAccount implements InterestBearing {
  double _minBalance = 500;
  double _interestRate = 0.02;
  double _withdrawlCount = 0;
  double _withdrawlLimit = 3;
  SavingsAccount(super._accNumber, super._accountHolderName, super._balance);

  @override
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print("Deposited Amount : ${amount}\nBalance : ${_balance}");
    }
  }

  //Withdrawal limit of 3 transactions per month
  @override
  void withdraw(double amount) {
    if (_withdrawlCount >= _withdrawlLimit) {
      print("User withdrawl limit reached(3)");
      return;
    }

    //Minimum balance requirement of $500
    if (_balance - amount < _minBalance) {
      print("Can't withdraw money, Min balance requires ${_minBalance}");
    } else {
      _balance -= amount;
      _withdrawlCount++;
      print(
        "After withdraw balance : ${_balance}, Wihtdrawn Amount: ${amount}",
      );
    }
  }

  //2% interest calculation method
  @override
  void calculateInterest() {
    double Interest = _balance * _interestRate;
    _balance += Interest;
    print(
      "Balance after interest : ${_balance}, Interest Amount : ${Interest}",
    );
  }
}

//Checking Account
class CheckingAccount extends BankAccount {
  double fine = 35;
  CheckingAccount(
    super._accountNumber,
    super._accountHolderName,
    super._balance,
  );

  @override
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print(
        "After deposited balance : ${_balance}, Deposited Amount : ${amount}",
      );
    }
  }

  //$35 overdraft fee if balance goes below $0
  @override
  void withdraw(double amount) {
    if (_balance < 0) {
      _balance -= fine;
      print(
        "Since user balance has gone into negative ${_balance}, User has to pay overdraft fee : ${fine}",
      );
    }
  }
}

//Premium Account
class PremiumAccount extends BankAccount implements InterestBearing {
  double _minBalance = 10000;
  double _interestRate = 0.05;
  PremiumAccount(
    super._accountNumber,
    super._accountHolderName,
    super._balance,
  );

  @override
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print(
        "After deposited balance : ${_balance}, Deposited Amount : ${amount}",
      );
    }
  }

  //Minimum balance of $10,000
  @override
  void withdraw(double amount) {
    if (_balance - amount < _minBalance) {
      print(
        "User current balance : ${_balance}, so user fall short of minimum balance ${_minBalance}",
      );
      return;
    }
  }

  //5% interest calculation
  @override
  void calculateInterest() {
    double Interest = _balance * _interestRate;
    _balance += Interest;
    print(
      "After inserting Interest : ${_balance}, Interest Amount : ${Interest}",
    );
  }
}

//Bank class
class Bank {
  List<BankAccount> _accounts = [];

  // Create new accounts
  void createAccount(BankAccount account) {
    _accounts.add(account);
    print("Account created for ${account._accountHolderName}");
  }

  // Find accounts by account Number
  BankAccount? FindAccount(int accountNumber) {
    for (var account in _accounts) {
      if (accountNumber == account._accountNumber) {
        return account;
      }
    }
    print("Account not found");
    return null;
  }

  // Transfer money between accounts
  void transfer(
    int senderAccountNumber,
    int receiverAccountNumber,
    double amount,
  ) {
    var senderAccount = FindAccount(senderAccountNumber);
    var receiverAccount = FindAccount(receiverAccountNumber);

    if (senderAccount == null || receiverAccount == null) {
      print("Transfer failed, account doesn't exist");
    } else {
      senderAccount.withdraw(amount);
      receiverAccount.deposit(amount);
      print(
        "Transferred $amount from $senderAccountNumber to $receiverAccount",
      );
    }
  }

  // Generate a report of all accounts
  void showAllAccounts() {
    for (var account in _accounts) {
      account.displayAccountinfo();
    }
  }
}

void main() {
  Bank bank = Bank();

  var acc1 = SavingsAccount(230399, "Aryan", 5000);
  var acc2 = CheckingAccount(230376, "Amit", 10000);
  var acc3 = PremiumAccount(230366, "Ishan", 15000);

  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);

  acc1.deposit(200);
  acc1.withdraw(300);
  acc1.calculateInterest();

  acc2.withdraw(600);
  acc3.calculateInterest();

  bank.transfer(230376, 230366, 250);
  bank.showAllAccounts();
}
