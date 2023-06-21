import 'package:flutter/material.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/screens/wallet_create_screen.dart';
import 'package:savings_app/screens/wallet_overview_screen.dart';
import 'package:savings_app/services/db.dart';
import 'package:savings_app/widgets/atoms/ScreenContainer.dart';
import 'package:savings_app/widgets/atoms/WalletCard.dart';

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({super.key});

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Wallet> _wallets = [];
  List<CashTransaction> _transactions = [];
  List<CashFlowCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    retrieveFromDB();
  }

  void retrieveFromDB() async {
    List<CashFlowCategory> categories =
        await _databaseService.retrieveCashFlowCategories();
    List<CashTransaction> transactions =
        await _databaseService.retrieveCashTransactions();

    setState(() {
      _categories = categories;
      _transactions = transactions;
    });
    retrieveWallets();
  }

  void retrieveWallets() async {
    List<Wallet> wallets = await _databaseService.retrieveWallets();
    setState(() {
      _wallets = wallets;
    });
  }

  void showCreateWalletScreen() async {
    Wallet result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const WalletCreateScreen()));

    await _databaseService.insertWallet(result);
    retrieveWallets();
  }

  void onWalletCardTap(Wallet wallet) async {
    WalletOverviewScreenResult result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WalletOverviewScreen(
                  wallet: wallet,
                  wallets: _wallets,
                  transactions: _transactions,
                  categories: _categories,
                )));

    switch (result.action) {
      case WalletOverviewScreenAction.delete:
        {
          await _databaseService.deleteWallet(result.wallet);
        }
        break;

      case WalletOverviewScreenAction.edit:
        {
          await _databaseService.updateWallet(result.wallet);
        }
    }

    retrieveWallets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text("Wallets")),
      body: ScreenContainer(
          child: ListView(
              children: _wallets
                  .map((wallet) =>
                      WalletCard(wallet: wallet, onTap: onWalletCardTap))
                  .toList())),
      floatingActionButton: FloatingActionButton(
          onPressed: showCreateWalletScreen, child: const Icon(Icons.add)),
    );
  }
}
