import 'package:flutter/material.dart';

class NumberStatCard extends StatelessWidget {
  const NumberStatCard(
      {super.key,
      required this.number,
      required this.description,
      required this.numberColor});

  final double number;
  final String description;
  final Color? numberColor;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shadowColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Text('${number.toString()}€',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: numberColor,
                    fontFamily: 'Numbers')),
            Text(description)
          ]),
        ));
  }
}
