import 'package:flutter/material.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/widgets/atoms/NumberStatCard.dart';
import 'package:savings_app/widgets/molecules/SummaryView.dart';
import 'package:savings_app/widgets/molecules/TimeSpanSelector.dart';
import 'package:savings_app/widgets/molecules/TransactionList.dart';

enum WalletOverviewScreenAction { edit, delete }

class WalletOverviewScreenResult {
  const WalletOverviewScreenResult(
      {required this.action, required this.wallet});

  final WalletOverviewScreenAction action;
  final Wallet wallet;
}

class WalletOverviewScreen extends StatefulWidget {
  const WalletOverviewScreen(
      {super.key,
      required this.wallet,
      required this.transactions,
      required this.categories});

  final Wallet wallet;
  final List<CashTransaction> transactions;
  final List<CashFlowCategory> categories;

  @override
  State<StatefulWidget> createState() => _WalletOverviewScreenState();
}

class _WalletOverviewScreenState extends State<WalletOverviewScreen>
    with TickerProviderStateMixin {
  late Wallet _wallet;
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
    _wallet = widget.wallet;
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
    void deleteWallet() {
      WalletOverviewScreenResult returnValue = WalletOverviewScreenResult(
          action: WalletOverviewScreenAction.delete, wallet: _wallet);

      Navigator.pop(context, returnValue);
    }

    void editWallet(String newName) {
      setState(() {
        _wallet.name = newName;
      });
    }

    void onPop() {
      WalletOverviewScreenResult returnValue = WalletOverviewScreenResult(
          action: WalletOverviewScreenAction.edit, wallet: _wallet);

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

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: onPop),
              centerTitle: true,
              title: Text(_wallet.name),
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
                  number: widget.wallet.balance,
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
                    transactions: widget.transactions,
                    categories: widget.categories,
                    wallet: _wallet,
                    timeSpan: _selectedTimeSpan,
                  ),
                  TransactionList(
                    categories: widget.categories,
                    wallets: [_wallet],
                    transactions: widget.transactions,
                    timeSpan: _selectedTimeSpan,
                  )
                ]))
              ],
            ))));
  }
}
