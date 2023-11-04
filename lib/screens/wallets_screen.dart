import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/providers/CategoryProvider.dart';
import 'package:savings_app/providers/TransactionProvider.dart';
import 'package:savings_app/providers/WalletProvider.dart';
import 'package:savings_app/screens/wallet_create_screen.dart';
import 'package:savings_app/screens/wallet_overview_screen.dart';
import 'package:savings_app/widgets/atoms/ScreenContainer.dart';
import 'package:savings_app/widgets/atoms/WalletCard.dart';

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({super.key, required this.walletBackgroundImages});

  final List<Image> walletBackgroundImages;

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<WalletProvider, TransactionProvider, CategoryProvider>(
        builder: (context, walletProvider, transactionProvider,
            categoryProvider, child) {
      void showCreateWalletScreen() async {
        Wallet newWallet = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WalletCreateScreen()));

        walletProvider.add(newWallet);
      }

      void onWalletCardTap(Wallet wallet) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider<WalletProvider>.value(
                              value: walletProvider),
                          ChangeNotifierProvider<TransactionProvider>.value(
                              value: transactionProvider),
                          ChangeNotifierProvider<CategoryProvider>.value(
                              value: categoryProvider),
                        ],
                        child: WalletOverviewScreen(
                          walletId: wallet.id,
                        ))));
      }

      return Scaffold(
        appBar: AppBar(centerTitle: false, title: const Text("Wallets")),
        body: ScreenContainer(
            child: ListView(
                children: walletProvider.wallets
                    .map((wallet) => WalletCard(
                          wallet: wallet,
                          onTap: onWalletCardTap,
                          images: widget.walletBackgroundImages,
                        ))
                    .toList())),
        floatingActionButton: FloatingActionButton(
            onPressed: showCreateWalletScreen, child: const Icon(Icons.add)),
      );
    });
  }
}
