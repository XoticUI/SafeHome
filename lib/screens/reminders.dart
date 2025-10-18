import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../models/models.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: app.reminders.map((r) => ListTile(title: Text(r.text))).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // stub: add a simple reminder
          app.addReminder(Reminder(id: DateTime.now().toIso8601String(), text: 'New reminder'));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
