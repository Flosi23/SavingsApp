import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/screens/wallet_overview_screen.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({super.key, required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    void navigateToWalletOverview(){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WalletOverviewScreen())
      );
    }

    final borderRadius = BorderRadius.circular(10);

    return Card(
      elevation: 1,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: InkWell(
        onTap: navigateToWalletOverview,
        borderRadius: borderRadius,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.wallet),
                  const SizedBox(width: 10),
                  Text(
                      wallet.name,
                      style: Theme.of(context).textTheme.bodyLarge
                  ),
                  const SizedBox(width: 10),
                  Text(
                      wallet.balance.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Numbers'
                      )
                  ),
                ]
              ),
              const Spacer(),
              const Icon(Icons.chevron_right)
            ],
          ),
        )
      )
    );
  }
}