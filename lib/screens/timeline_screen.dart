import 'package:flutter/material.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/screens/transaction_create_screen.dart';
import 'package:savings_app/services/db.dart';
import 'package:savings_app/widgets/atoms/TransactionView.dart';
import 'package:savings_app/widgets/molecules/TimeSpanSelector.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Wallet> _wallets = [];
  List<CashTransaction> _transactions = [];
  List<CashFlowCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    retrieveFromDB();
  }

  void retrieveFromDB() async {
    List<Wallet> wallets = await _databaseService.retrieveWallets();
    List<CashFlowCategory> categories =
        await _databaseService.retrieveCashFlowCategories();

    setState(() {
      _wallets = wallets;
      _categories = categories;
    });
    retrieveTransactions();
  }

  void retrieveTransactions() async {
    List<CashTransaction> transactions =
        await _databaseService.retrieveCashTransactions();
    setState(() {
      _transactions = transactions;
    });
  }

  void showAddTransactionScreen() async {
    CashTransaction? transaction = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TransactionCreateScreen(
                  wallets: _wallets,
                  categories: _categories,
                )));

    if (transaction != null) {
      await _databaseService.insertCashTransaction(transaction);
      retrieveTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Timeline"),
        ),
        body: SizedBox.expand(
            child: Column(
          children: [
            TimeSpanSelector(onChanged: (v) => {}),
            Expanded(
                child: ListView(
              children: _transactions.map((transaction) {
                Wallet wallet = _wallets
                    .where((wallet) => wallet.id == transaction.walletId)
                    .first;
                CashFlowCategory category = _categories
                    .where((category) => category.id == transaction.categoryId)
                    .first;

                return TransactionView(
                    transaction: transaction,
                    wallet: wallet,
                    category: category);
              }).toList(),
            ))
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: showAddTransactionScreen,
          child: const Icon(Icons.add),
        ));
  }
}
