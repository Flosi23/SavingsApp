import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDivider extends StatelessWidget {
  const TransactionDivider({super.key, required this.day, required this.sum});

  final DateTime day;
  final double sum;

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("MMMM dd");
    String dayString = format.format(day);

    return Card(
        elevation: 1,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(dayString), Text('$sum€')])));
  }
}
