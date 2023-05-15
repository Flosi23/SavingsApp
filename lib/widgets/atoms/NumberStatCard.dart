import 'package:flutter/material.dart';

class NumberStatCard extends StatelessWidget {
  const NumberStatCard({super.key, required this.text, required this.textColor});

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shadowColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: textColor,
                  fontFamily: 'Numbers'
              )
          ),
        )
    );
  }
}