import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/providers/CategoryProvider.dart';
import 'package:savings_app/providers/TransactionProvider.dart';
import 'package:savings_app/providers/WalletProvider.dart';
import 'package:savings_app/screens/transaction_create_screen.dart';
import 'package:savings_app/widgets/atoms/ScreenContainer.dart';
import 'package:savings_app/widgets/molecules/BarChartTimeSpanSelector.dart';
import 'package:savings_app/widgets/molecules/TimeSpanSelector.dart';
import 'package:savings_app/widgets/molecules/TransactionList.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
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
  }

  void updateSelectedTimeSpan(TimeSpan newTimeSpan) {
    setState(() {
      _selectedTimeSpan = newTimeSpan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WalletProvider, CategoryProvider>(
        builder: (context, walletProvider, categoryProvider, child) {
      void addTransactions(List<CashTransaction> transactions) {
        for (CashTransaction transaction in transactions) {
          Provider.of<TransactionProvider>(context, listen: false)
              .add(transaction, walletProvider);
        }
      }

      void showAddTransactionScreen() async {
        List<CashTransaction> transactions = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChangeNotifierProvider<CategoryProvider>.value(
                        value: categoryProvider,
                        child: TransactionCreateScreen(
                          wallets: walletProvider.wallets,
                        ))));

        addTransactions(transactions);
      }

      AppBar appBar = AppBar(centerTitle: false, title: const Text("Timeline"));

      if (walletProvider.wallets.isEmpty) {
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
              BarChartTimeSpanSelector(
                  wallets: walletProvider.wallets,
                  onChanged: updateSelectedTimeSpan,
                  defaultTimeSpan: _defaultTimeSpan),
              const SizedBox(height: 10),
              Expanded(
                  child: TransactionList(
                wallets: walletProvider.wallets,
                timeSpan: _selectedTimeSpan,
              ))
            ],
          )),
          floatingActionButton: FloatingActionButton(
            onPressed: showAddTransactionScreen,
            child: const Icon(Icons.add),
          ));
    });
  }
}
