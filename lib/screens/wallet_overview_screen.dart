import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/providers/TransactionProvider.dart';
import 'package:savings_app/providers/WalletProvider.dart';
import 'package:savings_app/widgets/atoms/NumberStatCard.dart';
import 'package:savings_app/widgets/molecules/SummaryView.dart';
import 'package:savings_app/widgets/molecules/TimeSpanSelector.dart';
import 'package:savings_app/widgets/molecules/TransactionList.dart';

class WalletOverviewScreen extends StatefulWidget {
  const WalletOverviewScreen({super.key, required this.walletId});

  final int walletId;

  @override
  State<StatefulWidget> createState() => _WalletOverviewScreenState();
}

class _WalletOverviewScreenState extends State<WalletOverviewScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  late TimeSpan _defaultTimeSpan;
  late TimeSpan _selectedTimeSpan;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _defaultTimeSpan = TimeSpan(
        start: DateTime(now.year, now.month, 1),
        end: DateTime(now.year, now.month + 1, 1));
    _selectedTimeSpan = _defaultTimeSpan;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void updateSelectedTimeSpan(TimeSpan newTimeSpan) {
    setState(() {
      _selectedTimeSpan = newTimeSpan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(builder: (context, walletProvider, child) {
      Wallet wallet = walletProvider.wallets
          .firstWhere((wallet) => wallet.id == widget.walletId);

      void deleteWallet() async {
        walletProvider.delete(
            wallet, Provider.of<TransactionProvider>(context, listen: false));
        Navigator.pop(context);
      }

      void editWallet(String newName) {
        wallet.name = newName;
        walletProvider.update(wallet);
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

      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
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
              body: SizedBox.expand(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NumberStatCard(
                    number: wallet.balance,
                    description: "Wallet Balance",
                    numberColor: null,
                  ),
                  const SizedBox(height: 20),
                  TimeSpanSelector(
                      defaultTimeSpan: _defaultTimeSpan,
                      onChanged: updateSelectedTimeSpan),
                  TabBar.secondary(controller: _tabController, tabs: const [
                    Tab(text: "Summary"),
                    Tab(text: "Transactions")
                  ]),
                  Expanded(
                      child: TabBarView(controller: _tabController, children: [
                    SummaryView(
                      wallet: wallet,
                      timeSpan: _selectedTimeSpan,
                    ),
                    TransactionList(
                      wallets: [wallet],
                      timeSpan: _selectedTimeSpan,
                    ),
                  ]))
                ],
              ))));
    });
  }
}
