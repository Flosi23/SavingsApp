import 'package:flutter/cupertino.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/providers/WalletProvider.dart';
import 'package:savings_app/services/db.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<CashTransaction> _transactions = [];

  TransactionProvider() {
    triggerUpdate();
  }

  _retrieveFromDB() async {
    _transactions = await _db.retrieveCashTransactions();
  }

  List<CashTransaction> get transactions => _transactions;

  void triggerUpdate() async {
    await _retrieveFromDB();
    notifyListeners();
  }

  void add(CashTransaction transaction, WalletProvider walletProvider) async {
    await _db.insertCashTransaction(transaction);
    triggerUpdate();
    walletProvider.triggerUpdate();
  }

  void delete(
      CashTransaction transaction, WalletProvider walletProvider) async {
    List<CashTransaction> transactions = _transactions
        .where((t) => t.transferId == transaction.transferId)
        .toList();

    for (CashTransaction transaction in transactions) {
      await _db.deleteCashTransaction(transaction);
    }
    triggerUpdate();
    walletProvider.triggerUpdate();
  }
}
