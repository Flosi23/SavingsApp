import 'package:flutter/material.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/transaction.dart';

List<Color> _colors() {
  const one = Color(0xff8da1b9);
  const two = Color(0xff95adb6);
  const three = Color(0xffCBB3BF);
  const four = Color(0xffDBC7BE);
  const five = Color(0xffEF959C);

  return [one, two, three, four, five];
}

class ReducedCategory {
  final String name;
  final IconData iconData;

  const ReducedCategory({
    required this.name,
    required this.iconData,
  });
}

List<CashFlowCategory> _defaultExpenseCategories() {
  var colors = _colors();

  const categories = [
    ReducedCategory(name: "Beauty", iconData: Icons.spa),
    ReducedCategory(name: "Bills & Fees", iconData: Icons.payment),
    ReducedCategory(name: "Clothing", iconData: Icons.checkroom),
    ReducedCategory(name: "Food & Drink", iconData: Icons.restaurant),
    ReducedCategory(name: "Gifts", iconData: Icons.redeem),
    ReducedCategory(name: "Groceries", iconData: Icons.shopping_basket),
    ReducedCategory(name: "Healthcare", iconData: Icons.medication),
    ReducedCategory(name: "Home", iconData: Icons.home),
    ReducedCategory(name: "Liqour", iconData: Icons.local_bar),
    ReducedCategory(name: "Music", iconData: Icons.music_note),
    ReducedCategory(name: "Other", iconData: Icons.question_mark),
    ReducedCategory(name: "Hardware/Computer", iconData: Icons.computer),
    ReducedCategory(name: "Shopping", iconData: Icons.shopping_bag),
    ReducedCategory(name: "Software", iconData: Icons.terminal),
    ReducedCategory(name: "Sports", iconData: Icons.sports_soccer),
    ReducedCategory(name: "Transport", iconData: Icons.train),
    ReducedCategory(name: "Travel", iconData: Icons.flight),
    ReducedCategory(name: "Untracked Expenses", iconData: Icons.search_off)
  ];

  return categories.asMap().entries.map((entry) {
    var index = entry.key;
    var category = entry.value;

    return CashFlowCategory(
        id: index,
        name: category.name,
        color: colors[index % colors.length],
        iconData: category.iconData,
        type: CashTransactionType.expense);
  }).toList();
}

List<CashFlowCategory> _defaultIncomeCategories() {
  var colors = _colors();

  const categories = [
    ReducedCategory(name: "Salary", iconData: Icons.payment),
    ReducedCategory(name: "Loan", iconData: Icons.account_balance),
    ReducedCategory(name: "Gift", iconData: Icons.redeem),
    ReducedCategory(name: "Other", iconData: Icons.question_mark),
    ReducedCategory(name: "Untracked Income", iconData: Icons.search_off)
  ];

  return categories.asMap().entries.map((entry) {
    var index = entry.key;
    var category = entry.value;

    return CashFlowCategory(
        id: index,
        name: category.name,
        color: colors[index % colors.length],
        iconData: category.iconData,
        type: CashTransactionType.income);
  }).toList();
}

List<CashFlowCategory> _defaultTransferCategories() {
  var colors = _colors();

  return [
    CashFlowCategory(
        id: 0,
        name: "Wallet Transfer",
        color: colors[0],
        iconData: Icons.swap_horiz,
        type: CashTransactionType.transfer)
  ];
}

List<CashFlowCategory> getDefaultCashFlowCategories() {
  return [
    ..._defaultExpenseCategories(),
    ..._defaultIncomeCategories(),
    ..._defaultTransferCategories()
  ];
}
