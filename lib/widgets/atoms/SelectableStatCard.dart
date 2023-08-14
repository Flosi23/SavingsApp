import 'package:flutter/material.dart';

class SelectableStatCard extends StatelessWidget {
  const SelectableStatCard({
    super.key,
    required this.selected,
    required this.title,
    required this.amount,
    required this.color,
    required this.onClicked,
  });

  final bool selected;
  final String title;
  final double amount;
  final Color color;
  final void Function() onClicked;

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(20);

    return GestureDetector(
        onTap: onClicked,
        child: Card(
            elevation: 1,
            shape: selected
                ? RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 2),
                    borderRadius: borderRadius)
                : null,
            shadowColor: Colors.transparent,
            surfaceTintColor: selected ? Colors.transparent : null,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Row(children: [
                Container(
                    height: 15,
                    width: 15,
                    margin: const EdgeInsets.only(right: 10),
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 2),
                  Text('${amount.toStringAsFixed(2)}€',
                      style: Theme.of(context).textTheme.headlineSmall)
                ])
              ]),
            )));
  }
}
