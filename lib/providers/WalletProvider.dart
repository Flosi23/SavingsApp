import 'package:flutter/cupertino.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/providers/TransactionProvider.dart';
import 'package:savings_app/services/db.dart';

class WalletProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Wallet> _wallets = [];

  WalletProvider() {
    triggerUpdate();
  }

  _retrieveFromDB() async {
    _wallets = await _db.retrieveWallets();
  }

  List<Wallet> get wallets => _wallets;

  void triggerUpdate() async {
    await _retrieveFromDB();
    notifyListeners();
  }

  void add(Wallet wallet) async {
    await _db.insertWallet(wallet);
    triggerUpdate();
  }

  void update(Wallet wallet) async {
    await _db.updateWallet(wallet);
    triggerUpdate();
  }

  void delete(Wallet wallet, TransactionProvider transactionProvider) async {
    await _db.deleteWallet(wallet);
    triggerUpdate();
    transactionProvider.triggerUpdate();
  }
}
