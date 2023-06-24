import 'package:flutter/cupertino.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/services/db.dart';

class CategoryProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<CashFlowCategory> _categories = [];

  CategoryProvider() {
    triggerUpdate();
  }

  _retrieveFromDB() async {
    _categories = await _db.retrieveCashFlowCategories();
  }

  triggerUpdate() async {
    await _retrieveFromDB();
    notifyListeners();
  }

  List<CashFlowCategory> get categories => _categories;
}
