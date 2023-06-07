import 'package:flutter/material.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';

class TransactionView extends StatelessWidget {
  const TransactionView(
      {super.key,
      required this.transaction,
      required this.wallet,
      required this.category});

  final CashTransaction transaction;
  final Wallet wallet;
  final CashFlowCategory category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(category.iconData),
        Column(
          children: [
            Text(category.name),
            Row(
              children: [const Icon(Icons.wallet), Text(wallet.name)],
            ),
            Row(
              children: [
                const Icon(Icons.description),
                Text(transaction.description)
              ],
            )
          ],
        ),
        Text('${transaction.amount}€')
      ],
    );
  }
}
