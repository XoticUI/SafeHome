import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../models/models.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final app = AppState.instance;
    

    return Scaffold(
      appBar: AppBar(title: const Text('SafeHome', style: TextStyle(fontSize: 20))),
      body: AnimatedBuilder(
        animation: app,
        builder: (context, _) {
          // rebuild pages based on latest app state
          final pages = [
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Safety Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: app.overallScore()),
                    const SizedBox(height: 16),
                    const Text('Rooms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: app.rooms.length,
                        itemBuilder: (context, index) {
                          final room = app.rooms[index];
                          final progress = app.roomProgress(room.id);
                          return ListTile(
                            title: Text(room.name, style: const TextStyle(fontSize: 18)),
                            subtitle: LinearProgressIndicator(value: progress),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _RoomPage(roomId: room.id))),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: app.reminders.map((r) => ListTile(title: Text(r.text))).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: app.contacts.map((c) => ListTile(title: Text(c.name), subtitle: Text(c.phone), trailing: IconButton(icon: const Icon(Icons.call), onPressed: () {}),)).toList(),
              ),
            ),
          ];

          return IndexedStack(index: _index, children: pages);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Reminders'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contacts'),
        ],
      ),
      floatingActionButton: _index == 1
          ? FloatingActionButton(
              onPressed: () => app.addReminder(Reminder(id: DateTime.now().toIso8601String(), text: 'New reminder')),
              child: const Icon(Icons.add),
            )
          : _index == 2
              ? FloatingActionButton(
                  onPressed: () => app.addContact(Contact(name: 'New Contact', phone: '555-000-0000')),
                  child: const Icon(Icons.add),
                )
              : null,
    );
  }
}

class _RoomPage extends StatelessWidget {
  final String roomId;
  const _RoomPage({required this.roomId});

  @override
  Widget build(BuildContext context) {
    final app = AppState.instance;
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        final room = app.rooms.firstWhere((r) => r.id == roomId);
        return Scaffold(
          appBar: AppBar(title: Text(room.name)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: room.items.length,
              itemBuilder: (context, index) {
                final item = room.items[index];
                return ListTile(
                  leading: Checkbox(value: item.done, onChanged: (_) => app.toggleItem(roomId, item.id)),
                  title: Text(item.text, style: const TextStyle(fontSize: 18)),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (context) {
                  final controller = TextEditingController();
                  return AlertDialog(
                    title: const Text('Add checklist item'),
                    content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'What to check?')),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.of(context).pop(controller.text), child: const Text('Add')),
                    ],
                  );
                },
              );
              if (result != null && result.trim().isNotEmpty) {
                app.addChecklistItem(roomId, result.trim());
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
