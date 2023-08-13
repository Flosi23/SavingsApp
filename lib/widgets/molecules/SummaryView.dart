import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/providers/CategoryProvider.dart';
import 'package:savings_app/providers/TransactionProvider.dart';
import 'package:savings_app/widgets/atoms/CashFlowCategoryIcon.dart';
import 'package:savings_app/widgets/atoms/NumberStatCard.dart';
import 'package:savings_app/widgets/molecules/TimeSpanSelector.dart';
import 'package:savings_app/widgets/molecules/pie_chart.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({super.key, required this.wallet, this.timeSpan});

  final Wallet wallet;
  final TimeSpan? timeSpan;

  @override
  State<StatefulWidget> createState() => _SummaryViewState();
}

enum TransactionFilterType { income, expense }

class _SummaryViewState extends State<SummaryView> {
  TransactionFilterType _selectedFilterType = TransactionFilterType.expense;

  @override
  void initState() {
    super.initState();
  }

  void updateSelectedTransactionType(
      Set<TransactionFilterType> newTransactionType) {
    setState(() {
      _selectedFilterType = newTransactionType.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionProvider, CategoryProvider>(
        builder: (context, transactionProvider, categoryProvider, child) {
      final Map<CashFlowCategory, double> categorySums = {};

      List<CashTransaction> filteredTransactions = transactionProvider
          .transactions
          .where((transaction) => transaction.walletId == widget.wallet.id)
          .toList();

      filteredTransactions = filteredTransactions
          .where((transaction) =>
              _selectedFilterType == TransactionFilterType.income
                  ? transaction.amount > 0
                  : transaction.amount < 0)
          .toList();

      if (widget.timeSpan != null) {
        filteredTransactions = filteredTransactions
            .where((transaction) =>
                (transaction.date.isAtSameMomentAs(widget.timeSpan!.start) ||
                    transaction.date.isAfter(widget.timeSpan!.start)) &&
                transaction.date.isBefore(widget.timeSpan!.end))
            .toList();
      }

      for (var transaction in filteredTransactions) {
        CashFlowCategory? category = categoryProvider.categories
            .where((category) => category.id == transaction.categoryId)
            .firstOrNull;

        if (category == null) continue;

        categorySums.update(category, (sum) => sum + transaction.amount,
            ifAbsent: () => transaction.amount);
      }

      final List<SectionData> chartData = categorySums.entries
          .map((entry) => SectionData(
              value: entry.value,
              color: entry.key.color,
              iconData: entry.key.iconData))
          .toList();

      double sum = filteredTransactions.fold(0,
          (previousValue, transaction) => previousValue + transaction.amount);

      return SingleChildScrollView(
          child: Column(children: [
        const SizedBox(height: 20),
        SegmentedButton(
          segments: const [
            ButtonSegment(
                value: TransactionFilterType.expense, label: Text("Expenses")),
            ButtonSegment(
                value: TransactionFilterType.income, label: Text("Income")),
          ],
          selected: {_selectedFilterType},
          onSelectionChanged: updateSelectedTransactionType,
        ),
        const SizedBox(height: 15),
        NumberStatCard(
            number: sum,
            description: _selectedFilterType == TransactionFilterType.income
                ? "Income"
                : "Expenses",
            numberColor: _selectedFilterType == TransactionFilterType.income
                ? Colors.greenAccent
                : Colors.redAccent),
        if (chartData.isNotEmpty) CategoryPieChart(chartData: chartData),
        ...categorySums.entries.map((entry) {
          int numberOfTransactions = filteredTransactions.fold(
              0,
              (previousValue, transaction) =>
                  transaction.categoryId == entry.key.id
                      ? previousValue + 1
                      : previousValue);

          return Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CashFlowCategoryIcon(category: entry.key),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.key.name,
                            style: Theme.of(context).textTheme.bodyLarge),
                        Text('$numberOfTransactions transactions',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  )),
                  Text('${entry.value.toStringAsFixed(2)}€',
                      style: Theme.of(context).textTheme.bodyLarge)
                ],
              ));
        }).toList(),
        const SizedBox(height: 50)
      ]));
    });
  }
}
