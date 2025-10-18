import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'room.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppState.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('SafeHome', style: TextStyle(fontSize: 20))),
      body: Padding(
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
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoomScreen(roomId: room.id))),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
