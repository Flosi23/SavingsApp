import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/providers/TransactionProvider.dart';
import 'package:savings_app/widgets/atoms/SummaryBarChart.dart';
import 'package:savings_app/widgets/molecules/TimeSpanSelector.dart';

class BarChartTimeSpanSelector extends StatefulWidget {
  const BarChartTimeSpanSelector(
      {super.key,
      required this.wallets,
      required this.onChanged,
      required this.defaultTimeSpan,
      this.backgroundColor});

  final List<Wallet> wallets;
  final void Function(TimeSpan value) onChanged;
  final TimeSpan defaultTimeSpan;
  final Color? backgroundColor;

  @override
  State<StatefulWidget> createState() => _BarChartTimespanSelectorState();
}

class _BarChartTimespanSelectorState extends State<BarChartTimeSpanSelector> {
  int currentPosition = 0;

  late TimeDuration duration = TimeDuration.month;
  late TimeSpan timeSpan;

  @override
  void initState() {
    super.initState();
    timeSpan = widget.defaultTimeSpan;
  }

  void setTimeSpan() {
    setState(() {
      timeSpan.change(duration, -currentPosition);
      widget.onChanged(timeSpan);
    });
  }

  void onPageChanged(int pagePosition) {
    setState(() {
      currentPosition = pagePosition;
      setTimeSpan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
      List<CashTransaction> transactions = transactionProvider.transactions
          .where((transaction) =>
              widget.wallets.map((w) => w.id).contains(transaction.walletId))
          .toList();
      transactions.sort((a, b) => b.date.compareTo(a.date));

      DateFormat format = DateFormat("MMM yy");

      final Map<String, List<CashTransaction>> groupedTransactions = {};
      for (CashTransaction transaction in transactions) {
        String key = format.format(transaction.date).toUpperCase();

        groupedTransactions.update(key, (list) {
          list.add(transaction);
          return list;
        }, ifAbsent: () => [transaction]);
      }

      String currentTimeSpanKey = format.format(timeSpan.start);

      Color borderColor = Colors.black12;
      double borderWidth = 0;

      return Container(
          height: 180,
          color: widget.backgroundColor,
          child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              scrollDirection: Axis.horizontal,
              reverse: true,
              separatorBuilder: (BuildContext context, int index) => Container(
                  height: 300, width: borderWidth, color: borderColor),
              itemCount: groupedTransactions.keys.length,
              itemBuilder: (BuildContext context, int index) {
                String key = groupedTransactions.keys.toList().elementAt(index);

                List<CashTransaction> transactions =
                    groupedTransactions[key] ?? [];
                double income = 0;
                double expenses = 0;
                for (CashTransaction transaction in transactions) {
                  transaction.amount > 0
                      ? income += transaction.amount
                      : expenses -= transaction.amount;
                }

                BarChartGroupData data =
                    BarChartGroupData(x: 0, barsSpace: 4, barRods: [
                  BarChartRodData(
                      toY: income, color: Colors.greenAccent, width: 20),
                  BarChartRodData(
                      toY: expenses, color: Colors.redAccent, width: 20)
                ]);

                bool selected =
                    key.toLowerCase() == currentTimeSpanKey.toLowerCase();

                return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Card(
                        shadowColor: Colors.transparent,
                        surfaceTintColor: selected ? null : Colors.transparent,
                        child: InkWell(
                            onTap: () => onPageChanged(index),
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                Expanded(
                                  child: AbsorbPointer(
                                      child: SummaryBarChart(data: [data])),
                                ),
                                const SizedBox(height: 10),
                                Text(key,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 10)
                              ],
                            ))));
              }));
    });
  }
}
