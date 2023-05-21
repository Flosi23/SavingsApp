import 'package:flutter/material.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/services/db.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wallets")),
      body:
      Container(
        margin: const EdgeInsets.all(20),
        child: FutureBuilder<List<Wallet>>(
          future: _wallets,
          builder: (context, snapshot) {
            if(snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Text("There are no wallets. Tap the + Button to create one");
            }

            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView(
                children: snapshot.data!.map((wallet) =>
                   WalletCard(wallet: wallet)
                ).toList()
              );
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: const Icon(Icons.add)
      ),
    );
  }
}