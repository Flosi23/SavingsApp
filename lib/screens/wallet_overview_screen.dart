import 'package:flutter/material.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/widgets/atoms/NumberStatCard.dart';
import 'package:savings_app/widgets/atoms/ScreenContainer.dart';
import 'package:savings_app/widgets/molecules/TimeSpanSelector.dart';
import 'package:savings_app/widgets/organisms/pie_chart.dart';

enum WalletOverviewScreenAction { edit, delete }

class WalletOverviewScreenResult {
  const WalletOverviewScreenResult(
      {required this.action, required this.wallet});

  final WalletOverviewScreenAction action;
  final Wallet wallet;
}

class WalletOverviewScreen extends StatefulWidget {
  const WalletOverviewScreen({super.key, required this.wallet});

  final Wallet wallet;

  @override
  State<StatefulWidget> createState() => WalletOverviewScreenState();
}

class WalletOverviewScreenState extends State<WalletOverviewScreen> {
  late Wallet wallet;

  @override
  void initState() {
    super.initState();
    wallet = widget.wallet;
  }

  @override
  Widget build(BuildContext context) {
    void deleteWallet() {
      WalletOverviewScreenResult returnValue = WalletOverviewScreenResult(
          action: WalletOverviewScreenAction.delete, wallet: wallet);

      Navigator.pop(context, returnValue);
    }

    void editWallet(String newName) {
      setState(() {
        wallet.name = newName;
      });
    }

    void onPop() {
      WalletOverviewScreenResult returnValue = WalletOverviewScreenResult(
          action: WalletOverviewScreenAction.edit, wallet: wallet);

      Navigator.pop(context, returnValue);
    }

    void showEditWalletDialog() async {
      TextEditingController nameController = TextEditingController();

      bool edit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Rename wallet"),
                content: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(hintText: "Name"),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Save"))
                ],
              ));

      if (edit) {
        String newName = nameController.text.toString();
        editWallet(newName);
      }
    }

    void showDeleteWalletDialog() async {
      bool delete = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Delete wallet?"),
                content: const Text(
                    "This action cannot be undone. If in doubt press the cancel button to go back"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Delete"))
                ],
              ));

      if (delete) {
        deleteWallet();
      }
    }

    List<SectionData> chartData = [
      SectionData(value: 40, color: Colors.blue, iconData: Icons.add),
      SectionData(value: 25, color: Colors.green, iconData: Icons.remove),
      SectionData(value: 10, color: Colors.teal, iconData: Icons.wallet),
      SectionData(value: 15, color: Colors.yellow, iconData: Icons.timeline),
      SectionData(
          value: 10, color: Colors.pinkAccent, iconData: Icons.settings),
    ];

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: onPop),
              centerTitle: true,
              title: Text(wallet.name),
              actions: [
                IconButton(
                    onPressed: showEditWalletDialog,
                    icon: const Icon(Icons.edit_outlined)),
                IconButton(
                    onPressed: showDeleteWalletDialog,
                    icon: const Icon(Icons.delete_outline))
              ],
            ),
            body: ScreenContainer(
                child: SizedBox.expand(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const NumberStatCard(
                  number: 45.56,
                  description: "Wallet Balance",
                  numberColor: null,
                ),
                TimespanSelector(onChanged: (v) => {}),
              ],
            )))));
  }
}
