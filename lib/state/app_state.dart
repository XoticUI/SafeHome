import 'package:flutter/foundation.dart';

import '../models/models.dart';

class AppState extends ChangeNotifier {
  AppState._internal() {
    _loadSampleData();
  }

  static final AppState instance = AppState._internal();

  final List<Room> rooms = [];
  final List<Reminder> reminders = [];
  final List<Contact> contacts = [];

  void _loadSampleData() {
    rooms.addAll([
      Room(
        id: 'kitchen',
        name: 'Kitchen',
        items: [
          ChecklistItem(id: 'k1', text: 'Check stove is off'),
          ChecklistItem(id: 'k2', text: 'Test smoke alarm'),
          ChecklistItem(id: 'k3', text: 'Clear floor of tripping hazards'),
        ],
      ),
      Room(
        id: 'bathroom',
        name: 'Bathroom',
        items: [
          ChecklistItem(id: 'b1', text: 'Check grab bars'),
          ChecklistItem(id: 'b2', text: 'Remove wet rugs'),
        ],
      ),
      Room(
        id: 'bedroom',
        name: 'Bedroom',
        items: [
          ChecklistItem(id: 'bd1', text: 'Clear night path to exit'),
          ChecklistItem(id: 'bd2', text: 'Test carbon monoxide detector'),
        ],
      ),
    ]);

    contacts.addAll([
      Contact(name: 'Primary Contact', phone: '555-123-4567'),
      Contact(name: 'Emergency Services', phone: '911'),
    ]);

    reminders.addAll([
      Reminder(id: 'r1', text: 'Change smoke alarm batteries (monthly)'),
    ]);
  }

  void toggleItem(String roomId, String itemId) {
    final room = rooms.firstWhere((r) => r.id == roomId, orElse: () => throw StateError('room'));
    final item = room.items.firstWhere((i) => i.id == itemId, orElse: () => throw StateError('item'));
    item.done = !item.done;
    notifyListeners();
  }

  double roomProgress(String roomId) {
    final room = rooms.firstWhere((r) => r.id == roomId, orElse: () => throw StateError('room'));
    if (room.items.isEmpty) return 0.0;
    final completed = room.items.where((i) => i.done).length;
    return completed / room.items.length;
  }

  double overallScore() {
    final all = rooms.expand((r) => r.items).toList();
    if (all.isEmpty) return 1.0;
    final completed = all.where((i) => i.done).length;
    return completed / all.length;
  }

  void addReminder(Reminder r) {
    reminders.add(r);
    notifyListeners();
  }

  void addContact(Contact c) {
    contacts.add(c);
    notifyListeners();
  }

  void addChecklistItem(String roomId, String text) {
    final room = rooms.firstWhere((r) => r.id == roomId, orElse: () => throw StateError('room'));
    final id = '${roomId}_${DateTime.now().millisecondsSinceEpoch}';
    room.items.add(ChecklistItem(id: id, text: text));
    notifyListeners();
  }
}
