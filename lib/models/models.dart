class ChecklistItem {
  final String id;
  final String text;
  bool done;

  ChecklistItem({required this.id, required this.text, this.done = false});
}

class Room {
  final String id;
  final String name;
  final List<ChecklistItem> items;

  Room({required this.id, required this.name, List<ChecklistItem>? items}) : items = items ?? [];
}

class Reminder {
  final String id;
  final String text;
  final String? frequency; // e.g. 'Monthly', 'Every 6 months', 'Weekly'
  final DateTime? dueDate;

  Reminder({required this.id, required this.text, this.frequency, this.dueDate});
}

class Contact {
  final String name;
  final String phone;
  final String? role;

  Contact({required this.name, required this.phone, this.role});
}
