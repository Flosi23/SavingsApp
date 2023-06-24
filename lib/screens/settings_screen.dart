import 'package:flutter/material.dart';
import 'package:savings_app/services/db.dart';
import 'package:savings_app/widgets/atoms/ScreenContainer.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final DatabaseService _dbService = DatabaseService();

  void _deleteDB() async {
    await _dbService.deleteDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ScreenContainer(
          child: FilledButton(
        onPressed: _deleteDB,
        child: const Text("Delete Database"),
      )),
    );
  }
}
