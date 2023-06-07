import 'package:flutter/material.dart';
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
  late Future<List<Wallet>> _wallets;

  @override
  void initState() {
    super.initState();
    _wallets = _databaseService.retrieveWallets();
  }

  void showCreateWalletScreen() async {
    Wallet result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const WalletCreateScreen()));

    await _databaseService.insertWallet(result);

    setState(() {
      _wallets = _databaseService.retrieveWallets();
    });
  }

  void onWalletCardTap(Wallet wallet) async {
    WalletOverviewScreenResult result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WalletOverviewScreen(wallet: wallet)));

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

    setState(() {
      _wallets = _databaseService.retrieveWallets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text("Wallets")),
      body: ScreenContainer(
          child: FutureBuilder<List<Wallet>>(
              future: _wallets,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Text(
                      "There are no wallets. Tap the + Button to create one");
                }

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView(
                      children: snapshot.data!
                          .map((wallet) => WalletCard(
                              wallet: wallet, onTap: onWalletCardTap))
                          .toList());
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              })),
      floatingActionButton: FloatingActionButton(
          onPressed: showCreateWalletScreen, child: const Icon(Icons.add)),
    );
  }
}
