import 'package:flutter/material.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/widgets/atoms/InputRow.dart';

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

  void cancel() {
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: cancel,
          ),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 15),
                child: FilledButton(
                    onPressed: createAndInsertWallet,
                    child: const Text("Save"))),
          ],
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              InputRow(
                  child: TextField(
                style: Theme.of(context).textTheme.headlineSmall,
                controller: _nameController,
                decoration: const InputDecoration(
                    hintText: "Name", border: InputBorder.none),
              )),
              const Divider(),
              InputRow(
                  icon: const Icon(Icons.payment),
                  child: TextField(
                    controller: _initialBalanceController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: "Initial Balance", border: InputBorder.none),
                  )),
              const Divider()
            ],
          ),
        ));
  }
}
