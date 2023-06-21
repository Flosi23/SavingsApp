import 'package:path/path.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/wallet.dart';
import 'package:savings_app/util/defaultCashFlowCategories.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'savings_app.db'),
      version: 3,
      onCreate: (database, version) async {
        await database.execute(CashFlowCategory.createTableStatement());
        await database.execute(Wallet.createTableStatement());
        await database.execute(CashTransaction.createTableStatement());

        var defaultCategories = getDefaultCashFlowCategories();
        for (final cashFlowCategory in defaultCategories) {
          await database.insert(
              CashFlowCategory.tableName, cashFlowCategory.toMap());
        }
      },
    );
  }

  Future<void> deleteDB() async {
    String path = await getDatabasesPath();
    return deleteDatabase(path);
  }

  Future<int> insertCashFlowCategory(CashFlowCategory cashFlowCategory) async {
    final Database db = await initializeDB();
    return await db.insert(
        CashFlowCategory.tableName, cashFlowCategory.toMap());
  }

  Future<List<CashFlowCategory>> retrieveCashFlowCategories() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query(CashFlowCategory.tableName);
    return queryResult
        .map((result) => CashFlowCategory.fromMap(result))
        .toList();
  }

  Future<void> insertWallet(Wallet wallet) async {
    final Database db = await initializeDB();
    await db.insert(Wallet.tableName, wallet.toMap());
  }

  Future<void> deleteWallet(Wallet wallet) async {
    final Database db = await initializeDB();

    db.transaction((txn) async {
      await txn.delete(CashTransaction.tableName,
          where: 'walletId = ${wallet.id}');
      await txn.delete(Wallet.tableName, where: "id = ${wallet.id}");
    });
  }

  Future<void> updateWallet(Wallet wallet) async {
    final Database db = await initializeDB();
    await db.update(Wallet.tableName, wallet.toMap(),
        where: "id = ${wallet.id}");
  }

  Future<List<Wallet>> retrieveWallets() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query(Wallet.tableName);

    return queryResult.map((result) => Wallet.fromMap(result)).toList();
  }

  Future<void> insertCashTransaction(CashTransaction cashTransaction) async {
    final Database db = await initializeDB();

    db.transaction((txn) async {
      await txn.rawUpdate(
          'UPDATE ${Wallet.tableName} SET balance = balance + ${cashTransaction.amount} WHERE id = ${cashTransaction.walletId}');
      await txn.insert(CashTransaction.tableName, cashTransaction.toMap());
    });
  }

  Future<void> deleteCashTransaction(CashTransaction cashTransaction) async {
    final Database db = await initializeDB();
    await db.delete(CashTransaction.tableName,
        where: 'id = ${cashTransaction.id}');
  }

  Future<List<CashTransaction>> retrieveCashTransactions() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query(CashTransaction.tableName);
    return queryResult
        .map((result) => CashTransaction.fromMap(result))
        .toList();
  }
}
