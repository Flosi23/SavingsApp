import 'package:flutter/material.dart';
import 'package:savings_app/models/wallet.dart';

typedef OnTap = void Function(Wallet wallet);

class WalletCard extends StatelessWidget {
  const WalletCard(
      {super.key,
      required this.wallet,
      required this.onTap,
      required this.images});

  final OnTap onTap;
  final Wallet wallet;
  final List<Image> images;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);

    return GestureDetector(
        onTap: () => {onTap(wallet)},
        child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 1,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(wallet.name,
                                style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 10),
                            Text('${wallet.balance.toStringAsFixed(2)}€',
                                style:
                                    Theme.of(context).textTheme.headlineLarge)
                          ])),
                  Expanded(
                      child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: images[wallet.id % 5].image,
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.cover)),
                          child: null))
                ])));
  }
}
