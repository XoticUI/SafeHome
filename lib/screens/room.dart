import 'package:flutter/material.dart';
import '../state/app_state.dart';

class RoomScreen extends StatelessWidget {
  final String roomId;

  const RoomScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final app = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: Text(app.rooms.firstWhere((r) => r.id == roomId).name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: app,
          builder: (context, _) {
            final room = app.rooms.firstWhere((r) => r.id == roomId);
            return ListView.builder(
              itemCount: room.items.length,
              itemBuilder: (context, index) {
                final item = room.items[index];
                return ListTile(
                  leading: Checkbox(
                    value: item.done,
                    onChanged: (_) => app.toggleItem(roomId, item.id),
                  ),
                  title: Text(item.text, style: const TextStyle(fontSize: 18)),
                );
              },
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
  }
}
