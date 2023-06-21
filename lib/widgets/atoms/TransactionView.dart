import 'package:flutter/material.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/widgets/atoms/CashFlowCategoryIcon.dart';

class TransactionView extends StatelessWidget {
  const TransactionView(
      {super.key,
      required this.transaction,
      required this.wallets,
      required this.categories});

  final CashTransaction transaction;
  final List<Wallet> wallets;
  final List<CashFlowCategory> categories;

  @override
  Widget build(BuildContext context) {
    CashFlowCategory? category = categories
        .where((category) => category.id == transaction.categoryId)
        .firstOrNull;

    if (category == null) return Container();

    Wallet? wallet = wallets
        .where((wallet) => wallet.id == transaction.walletId)
        .firstOrNull;

    if (wallet == null) {
      return Container();
    }

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CashFlowCategoryIcon(category: category),
            ),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.wallet,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(wallet.name,
                                style: Theme.of(context).textTheme.bodyMedium)
                          ],
                        ),
                        if (transaction.description.isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.notes, size: 20),
                              const SizedBox(width: 5),
                              Text(
                                transaction.description,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                          )
                      ],
                    ))),
            Text('${transaction.amount.toStringAsFixed(2)}€',
                style: TextStyle(
                    fontSize: 15,
                    color: transaction.type == CashTransactionType.transfer
                        ? Colors.black
                        : transaction.type == CashTransactionType.income
                            ? Colors.greenAccent
                            : Colors.redAccent))
          ],
        ));
  }
}
