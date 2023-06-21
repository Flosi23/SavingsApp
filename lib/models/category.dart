import 'package:flutter/material.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/util/IconData.dart';

class CashFlowCategory {
  final int id;
  final String name;
  final Color color;
  final IconData iconData;
  final CashTransactionType type;

  static String tableName = 'cash_flow_category';

  const CashFlowCategory({
    required this.id,
    required this.name,
    required this.color,
    required this.iconData,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': color.value,
      'iconData': iconDataToJSONString(iconData),
      'type': type.name,
    };
  }

  static CashFlowCategory fromMap(Map<String, dynamic> map) {
    return CashFlowCategory(
      id: map['id'],
      name: map['name'],
      color: Color(map['color']),
      iconData: iconDatafromJSONString(map['iconData']),
      type: CashTransactionType.values
          .firstWhere((element) => element.name == map['type']),
    );
  }

  static String createTableStatement() {
    return '''
      create table $tableName (
        id integer primary key autoincrement,
        name text not null,
        color integer,
        iconData text not null,
        type text not null
      ) 
    ''';
  }
}
