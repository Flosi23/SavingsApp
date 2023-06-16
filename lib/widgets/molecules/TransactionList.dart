import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/widgets/atoms/TransactionDivider.dart';
import 'package:savings_app/widgets/atoms/TransactionView.dart';
import 'package:savings_app/widgets/molecules/TimeSpanSelector.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(
      {super.key,
      required this.categories,
      required this.wallets,
      required this.transactions,
      this.timeSpan});

  final List<CashFlowCategory> categories;
  final List<Wallet> wallets;
  final List<CashTransaction> transactions;
  final TimeSpan? timeSpan;

  @override
  Widget build(BuildContext context) {
    List<CashTransaction> filteredTransactions = transactions;

    if (timeSpan != null) {
      filteredTransactions = transactions
          .where((transaction) =>
              (transaction.date.isAtSameMomentAs(timeSpan!.start) ||
                  transaction.date.isAfter(timeSpan!.start)) &&
              transaction.date.isBefore(timeSpan!.end))
          .toList();
    }

    Map<String, List<CashTransaction>> selectedTransactions = {};

    for (var transaction in filteredTransactions) {
      DateFormat dateFormat = DateFormat("MMMM dd");
      String dateString = dateFormat.format(transaction.date);

      selectedTransactions.update(dateString, (list) {
        list.add(transaction);
        return list;
      }, ifAbsent: () => [transaction]);
    }

    if (wallets.isEmpty || categories.isEmpty) {
      return Container();
    }

    return ListView(
        children: selectedTransactions.entries
            .map((entry) {
              double sum = entry.value.fold(
                  0,
                  (previousValue, transaction) =>
                      previousValue + transaction.amount);

              TransactionDivider transactionDivider =
                  TransactionDivider(dateString: entry.key, sum: sum);

              List<TransactionView> transactions =
                  entry.value.map((transaction) {
                Wallet wallet = wallets
                    .where((wallet) => wallet.id == transaction.walletId)
                    .first;
                CashFlowCategory category = categories
                    .where((category) => category.id == transaction.categoryId)
                    .first;

                return TransactionView(
                    transaction: transaction,
                    wallet: wallet,
                    category: category);
              }).toList();

              return [transactionDivider, ...transactions];
            })
            .expand((e) => e)
            .toList());
  }
}
