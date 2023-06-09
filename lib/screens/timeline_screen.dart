import 'package:flutter/material.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/screens/transaction_create_screen.dart';
import 'package:savings_app/services/db.dart';
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
    _wallets = await _databaseService.retrieveWallets();
    _transactions = await _databaseService.retrieveCashTransactions();
    _categories = await _databaseService.retrieveCashFlowCategories();
  }

  void showAddTransactionScreen() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TransactionCreateScreen(
                  wallets: _wallets,
                  categories: _categories,
                )));
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
              children: [],
            ))
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: showAddTransactionScreen,
          child: const Icon(Icons.add),
        ));
  }
}
