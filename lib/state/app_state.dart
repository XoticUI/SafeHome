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
      Contact(name: 'Emergency Services', phone: '911', protected: true),
    ]);

    reminders.addAll([
      Reminder(id: 'r1', text: 'Test smoke alarms', frequency: 'Monthly', dueDate: DateTime(2025, 10, 31)),
      Reminder(id: 'r2', text: 'Replace smoke alarm batteries', frequency: 'Every 6 months', dueDate: DateTime(2026, 3, 31)),
      Reminder(id: 'r3', text: 'Check fire extinguisher', frequency: 'Yearly', dueDate: DateTime(2026, 1, 14)),
      Reminder(id: 'r4', text: 'Clean dryer lint trap', frequency: 'Weekly', dueDate: DateTime(2025, 10, 24)),
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

  void removeContact(Contact c) {
    // do not remove protected contacts (e.g. 911)
    contacts.removeWhere((x) => !(x.protected) && x.name == c.name && x.phone == c.phone);
    notifyListeners();
  }

  void addChecklistItem(String roomId, String text) {
    final room = rooms.firstWhere((r) => r.id == roomId, orElse: () => throw StateError('room'));
    final id = '${roomId}_${DateTime.now().millisecondsSinceEpoch}';
    room.items.add(ChecklistItem(id: id, text: text));
    notifyListeners();
  }

  void addRoom(String name) {
    final id = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    if (rooms.any((r) => r.id == id)) return;
    rooms.add(Room(id: id, name: name, items: []));
    notifyListeners();
  }
}
