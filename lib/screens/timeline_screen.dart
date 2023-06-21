import 'package:flutter/material.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/screens/transaction_create_screen.dart';
import 'package:savings_app/services/db.dart';
import 'package:savings_app/widgets/atoms/ScreenContainer.dart';
import 'package:savings_app/widgets/molecules/TimeSpanSelector.dart';
import 'package:savings_app/widgets/molecules/TransactionList.dart';

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
  late TimeSpan _selectedTimeSpan;
  late TimeSpan _defaultTimeSpan;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _defaultTimeSpan = TimeSpan(
        start: DateTime(now.year, now.month, 1),
        end: DateTime(now.year, now.month + 1, 1));
    _selectedTimeSpan = _defaultTimeSpan;
    retrieveFromDB();
  }

  void retrieveFromDB() async {
    await _databaseService.deleteDB();
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

  void updateSelectedTimeSpan(TimeSpan newTimeSpan) {
    setState(() {
      _selectedTimeSpan = newTimeSpan;
    });
  }

  void showAddTransactionScreen() async {
    List<CashTransaction> transactions = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TransactionCreateScreen(
                  wallets: _wallets,
                  categories: _categories,
                )));

    for (CashTransaction transaction in transactions) {
      await _databaseService.insertCashTransaction(transaction);
    }

    retrieveTransactions();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(centerTitle: false, title: const Text("Timeline"));

    if (_wallets.isEmpty) {
      return Scaffold(
        appBar: appBar,
        body: ScreenContainer(
            child: const Text("Add a wallet to see and add transactions")),
      );
    }

    return Scaffold(
        appBar: appBar,
        body: SizedBox.expand(
            child: Column(
          children: [
            const SizedBox(height: 20),
            TimeSpanSelector(
                defaultTimeSpan: _defaultTimeSpan,
                onChanged: updateSelectedTimeSpan),
            Expanded(
                child: TransactionList(
              categories: _categories,
              wallets: _wallets,
              transactions: _transactions,
              timeSpan: _selectedTimeSpan,
            ))
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: showAddTransactionScreen,
          child: const Icon(Icons.add),
        ));
  }
}
