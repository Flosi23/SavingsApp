import 'package:flutter/material.dart';
import 'package:savings_app/models/wallet.dart';

typedef OnTap = void Function(Wallet wallet);

class WalletCard extends StatelessWidget {
  const WalletCard({super.key, required this.wallet, required this.onTap});

  final OnTap onTap;
  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);

    return Card(
        elevation: 1,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        child: InkWell(
            onTap: () => {onTap(wallet)},
            borderRadius: borderRadius,
            child: Container(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Icon(Icons.wallet, size: 25),
                    const SizedBox(width: 10),
                    Text(wallet.name, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Text('${wallet.balance.toStringAsFixed(2)}€',
                        style: const TextStyle(fontSize: 18))
                  ]),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 20)
                ],
              ),
            )));
  }
}
