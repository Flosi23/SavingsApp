import 'package:flutter/material.dart';
import 'package:savings_app/util/IconData.dart';

class CashFlowCategory {
  final int id;
  final String name;
  final Color color;
  final IconData iconData;
  final bool isIncomeCategory;

  static String tableName = 'cash_flow_category';

  const CashFlowCategory({
    required this.id,
    required this.name,
    required this.color,
    required this.iconData,
    required this.isIncomeCategory,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'iconData': iconDataToJSONString(iconData),
      'isIncomeCategory': isIncomeCategory
    };
  }

  static CashFlowCategory fromMap(Map<String, dynamic> map) {
    return CashFlowCategory(
      id: map['id'],
      name: map['name'],
      color: Color(map['color']),
      iconData: iconDatafromJSONString(map['iconData']),
      isIncomeCategory: map['isIncomeCategory'] == 1
    );
  }

  static String createTableStatement() {
    return '''
      create table $tableName (
        id integer primary key autoincrement,
        name text not null,
        color integer,
        iconData text not null,
        isIncomeCategory integer 
      ) 
    ''';
  }
}
