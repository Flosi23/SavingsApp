import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/screens/transaction_create_screen.dart';
import 'package:savings_app/services/db.dart';
import 'package:savings_app/widgets/atoms/ScreenContainer.dart';
import 'package:savings_app/widgets/atoms/TransactionDivider.dart';
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
  Map<String, List<CashTransaction>> _selectedTransactions = {};
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
    updateSelectedTransactions();
  }

  void updateSelectedTransactions() {
    List<CashTransaction> filteredTransactions = _transactions
        .where((transaction) =>
            (transaction.date.isAtSameMomentAs(_selectedTimeSpan.start) ||
                transaction.date.isAfter(_selectedTimeSpan.start)) &&
            transaction.date.isBefore(_selectedTimeSpan.end))
        .toList();

    Map<String, List<CashTransaction>> newSelectedTransactions = {};

    for (var transaction in filteredTransactions) {
      DateFormat dateFormat = DateFormat("MMMM dd");
      String dateString = dateFormat.format(transaction.date);

      newSelectedTransactions.update(dateString, (list) {
        list.add(transaction);
        return list;
      }, ifAbsent: () => [transaction]);
    }

    debugPrint("newSelectedTransactions: $newSelectedTransactions");

    setState(() {
      _selectedTransactions = newSelectedTransactions;
    });
  }

  void updateSelectedTimeSpan(TimeSpan newTimeSpan) {
    setState(() {
      _selectedTimeSpan = newTimeSpan;
    });
    updateSelectedTransactions();
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
                child: ListView(
                    children: _selectedTransactions.entries
                        .map((entry) {
                          TransactionDivider transactionDivider =
                              TransactionDivider(dateString: entry.key, sum: 0);

                          List<TransactionView> transactions =
                              entry.value.map((transaction) {
                            Wallet wallet = _wallets
                                .where((wallet) =>
                                    wallet.id == transaction.walletId)
                                .first;
                            CashFlowCategory category = _categories
                                .where((category) =>
                                    category.id == transaction.categoryId)
                                .first;

                            return TransactionView(
                                transaction: transaction,
                                wallet: wallet,
                                category: category);
                          }).toList();

                          return [transactionDivider, ...transactions];
                        })
                        .expand((e) => e)
                        .toList()))
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: showAddTransactionScreen,
          child: const Icon(Icons.add),
        ));
  }
}
