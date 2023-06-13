class CashTransaction {
  final int id;
  final int walletId;
  final int categoryId;
  final double amount;
  final String description;
  final DateTime date;

  static String tableName = 'cash_transaction';

  const CashTransaction({
    required this.id,
    required this.walletId,
    required this.categoryId,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'walletId': walletId,
      'categoryId': categoryId,
      'amount': amount,
      'description': description,
      'date': date.millisecondsSinceEpoch
    };
  }

  static CashTransaction fromMap(Map<String, dynamic> map) {
    return CashTransaction(
        id: map['id'],
        walletId: map['walletId'],
        categoryId: map['categoryId'],
        amount: map['amount'],
        description: map['description'],
        date: DateTime.fromMillisecondsSinceEpoch(map['date']));
  }

  static String createTableStatement() {
    return '''
     create table $tableName (
      id integer primary key autoincrement,
      walletId integer,
      categoryId integer,
      amount double,
      description text not null,
      date datetime
     ) 
    ''';
  }
}
