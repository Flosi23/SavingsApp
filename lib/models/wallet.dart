class Wallet {
  final int id;
  String name;
  double balance;
  final double initialBalance;

  static String tableName = 'wallet';

  Wallet({
    required this.id,
    required this.name,
    required this.balance,
    required this.initialBalance,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'balance': balance, 'initialBalance': initialBalance};
  }

  static Wallet fromMap(Map<String, dynamic> map) {
    return Wallet(
        id: map['id'],
        name: map['name'],
        balance: map['balance'],
        initialBalance: map['initialBalance']);
  }

  static String createTableStatement() {
    return '''
      create table $tableName (
        id integer primary key autoincrement,
        name text not null,
        balance double,
        initialBalance double
      )
    ''';
  }
}
