import 'package:flutter/material.dart';

class TransactionDivider extends StatelessWidget {
  const TransactionDivider(
      {super.key, required this.dateString, required this.sum});

  final String dateString;
  final double sum;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
            padding:
                const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateString,
                      style: Theme.of(context).textTheme.titleSmall),
                  Text('${sum.toStringAsFixed(2)}€',
                      style: Theme.of(context).textTheme.titleSmall)
                ])));
  }
}
