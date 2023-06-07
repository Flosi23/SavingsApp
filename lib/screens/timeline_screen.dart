import 'package:flutter/material.dart';
import 'package:savings_app/models/wallet.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late List<Wallet> wallets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Timeline"),
      ),
      body: Container(margin: const EdgeInsets.all(10)),
    );
  }
}
