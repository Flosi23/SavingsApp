import 'package:flutter/material.dart';

class NoTransactionsFound extends StatelessWidget {
  const NoTransactionsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Image(
        image: AssetImage("./assets/images/notfound.png"),
        width: 100,
        height: 100,
      ),
      const SizedBox(height: 10),
      Text("No Transactions", style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 5),
      Text("Add transactions in the timeline screen",
          style: Theme.of(context).textTheme.bodySmall)
    ]);
  }
}
