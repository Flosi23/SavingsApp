import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/providers/CategoryProvider.dart';
import 'package:savings_app/providers/TransactionProvider.dart';
import 'package:savings_app/providers/WalletProvider.dart';
import 'package:savings_app/widgets/atoms/TransactionDivider.dart';
import 'package:savings_app/widgets/atoms/TransactionView.dart';
import 'package:savings_app/widgets/molecules/TimeSpanSelector.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key, required this.wallets, this.timeSpan});

  final List<Wallet> wallets;
  final TimeSpan? timeSpan;

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionProvider, CategoryProvider>(
        builder: (context, transactionProvider, categoryProvider, child) {
      Future<bool> confirmDismiss(DismissDirection dismissDirection) async {
        return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Delete transaction?"),
                  content: const Text(
                      "This action cannot be undone. If in doubt press the cancel button to go back"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Delete"))
                  ],
                ));
      }

      deleteTransaction(CashTransaction transaction) {
        return (DismissDirection dismissDirection) async {
          transactionProvider.delete(
              transaction, Provider.of<WalletProvider>(context, listen: false));
        };
      }

      List<CashTransaction> filteredTransactions =
          transactionProvider.transactions;

      if (timeSpan != null) {
        filteredTransactions = filteredTransactions
            .where((transaction) =>
                (transaction.date.isAtSameMomentAs(timeSpan!.start) ||
                    transaction.date.isAfter(timeSpan!.start)) &&
                transaction.date.isBefore(timeSpan!.end) &&
                wallets
                    .where((wallet) => wallet.id == transaction.walletId)
                    .isNotEmpty)
            .toList();
      }

      filteredTransactions.sort(
          (CashTransaction a, CashTransaction b) => b.date.compareTo(a.date));

      Map<String, List<CashTransaction>> selectedTransactions = {};

      for (var transaction in filteredTransactions) {
        DateFormat dateFormat = DateFormat("MMMM dd");
        String dateString = dateFormat.format(transaction.date);

        selectedTransactions.update(dateString, (list) {
          list.add(transaction);
          return list;
        }, ifAbsent: () => [transaction]);
      }

      if (wallets.isEmpty || categoryProvider.categories.isEmpty) {
        return Container();
      }

      return Column(
          children: selectedTransactions.entries
              .map((entry) {
                double sum = entry.value.fold(
                    0,
                    (previousValue, transaction) =>
                        transaction.type != CashTransactionType.transfer
                            ? previousValue + transaction.amount
                            : previousValue);

                TransactionDivider transactionDivider =
                    TransactionDivider(dateString: entry.key, sum: sum);

                List<Widget> transactions = entry.value.map((transaction) {
                  return Dismissible(
                      confirmDismiss: confirmDismiss,
                      onDismissed: deleteTransaction(transaction),
                      key: Key(transaction.id.toString()),
                      background: Container(
                        alignment: AlignmentDirectional.centerStart,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xffFFDDAA),
                        ),
                        child: const SizedBox(
                            width: 90,
                            child: Center(child: Icon(Icons.delete_forever))),
                      ),
                      direction: DismissDirection.startToEnd,
                      child: TransactionView(
                          transaction: transaction,
                          wallets: wallets,
                          categories: categoryProvider.categories));
                }).toList();

                return [transactionDivider, ...transactions];
              })
              .expand((e) => e)
              .toList());
    });
  }
}
