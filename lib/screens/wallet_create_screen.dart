import 'package:flutter/material.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/widgets/atoms/ScreenContainer.dart';

class WalletCreateScreen extends StatefulWidget {
  const WalletCreateScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WalletCreateScreenState();
}

class _WalletCreateScreenState extends State<WalletCreateScreen> {
  late TextEditingController _nameController;
  late TextEditingController _initialBalanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _initialBalanceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  void createAndInsertWallet() {
    String name = _nameController.value.text.toString();
    String initialBalanceString =
        _initialBalanceController.value.text.toString();
    double initialBalance = double.parse(initialBalanceString);

    Wallet wallet = Wallet(
        id: 0,
        name: name,
        balance: initialBalance,
        initialBalance: initialBalance);

    Navigator.pop(context, wallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Create a new wallet"),
        ),
        body: ScreenContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      hintText: "Name", prefixIcon: Icon(Icons.wallet)),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _initialBalanceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontFamily: "Numbers"),
                  decoration: const InputDecoration(
                      hintText: "Initial Balance",
                      prefixIcon: Icon(Icons.payments),
                      suffixIcon: Icon(Icons.euro)),
                )
              ]),
              FilledButton(
                  onPressed: createAndInsertWallet,
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(50))),
                  child: const Text("Create Wallet"))
            ],
          ),
        ));
  }
}
