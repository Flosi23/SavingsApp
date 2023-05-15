import 'package:path/path.dart';
import 'package:savings_app/models/category.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'savings_app.db'),
      onCreate: (database, version) async {
        await database.execute(CashFlowCategory.createTableStatement());
      }
    );
  }

  Future<int> insertCashFlowCategory(CashFlowCategory cashFlowCategory) async {
    final Database db = await initializeDB();
    return await db.insert(CashFlowCategory.tableName, cashFlowCategory.toMap());
  }

  Future<List<CashFlowCategory>> retrieveCategories() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(CashFlowCategory.tableName);
    return queryResult.map((result) => CashFlowCategory.fromMap(result)).toList();
  }
}