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
      appBar: AppBar(
        toolbarHeight: 96,
        title: _index == 0
            ? const Center(child: Text('SafeHome', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600)))
            : const Text('SafeHome', style: TextStyle(fontSize: 20)),
        automaticallyImplyLeading: false,
      ),
      body: AnimatedBuilder(
        animation: app,
  builder: (context, _) {
          // rebuild pages based on latest app state
          // Build pages: 0=Home, 1=Checks, 2=Reminders, 3=Emergency/Contacts
          final homePage = SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Safety Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Safety Score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${(app.overallScore() * 100).round()}%', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                              const Icon(Icons.warning_amber_rounded, color: Colors.amber),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(value: app.overallScore()),
                          const SizedBox(height: 12),
                          Text('Rooms Checked: ${app.rooms.where((r) => r.items.every((i) => i.done)).length} of ${app.rooms.length}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: app.overallScore()),
                  const SizedBox(height: 16),
                  
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                              children: [
                                const Icon(Icons.home, size: 28),
                                const SizedBox(height: 8),
                                Text('${app.rooms.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                const Text('Rooms'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.green, size: 28),
                                const SizedBox(height: 8),
                                Text('${(app.rooms.expand((r) => r.items).where((i) => i.done).length)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                const Text('Items Safe'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () => setState(() => _index = 1),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Colors.black87,
                        ),
                        child: const Text('Start Safety Check', style: TextStyle(fontSize: 20, color: Colors.white)),
                        // Text(label, style: TextStyle(color: selected ? Colors.black87 : Colors.grey[600])),
  
  
                      ),
                  ),
                  const SizedBox(height: 18),
                  Card(
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.blue.shade100)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(children: [Icon(Icons.lightbulb, color: Colors.orange), SizedBox(width: 8), Text('Safety Tip', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))]),
                          SizedBox(height: 12),
                          Text('Check your smoke alarm batteries every 6 months. A working smoke alarm can cut the risk of dying in a fire by half.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          final checksPage = Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.builder(
              itemCount: app.rooms.length,
              itemBuilder: (context, idx) {
                final room = app.rooms[idx];
                final progress = app.roomProgress(room.id);
                IconData icon;
                switch (room.id) {
                  case 'kitchen':
                    icon = Icons.kitchen;
                    break;
                  case 'bathroom':
                    icon = Icons.shower;
                    break;
                  case 'bedroom':
                    icon = Icons.bed;
                    break;
                  case 'living':
                    icon = Icons.weekend;
                    break;
                  case 'stairs':
                    icon = Icons.stairs;
                    break;
                  default:
                    icon = Icons.room;
                }
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => _RoomPage(roomId: room.id))),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(icon, size: 36),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(room.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(value: progress, minHeight: 12),
                                ),
                                const SizedBox(height: 8),
                                Text('${room.items.where((i) => i.done).length} of ${room.items.length} items', style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );

          final remindersPage = Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: app.reminders.map((r) => ListTile(title: Text(r.text))).toList(),
            ),
          );

          final emergencyPage = Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: app.contacts.map((c) => ListTile(title: Text(c.name), subtitle: Text(c.phone), trailing: IconButton(icon: const Icon(Icons.call), onPressed: () {}),)).toList(),
            ),
          );

          return IndexedStack(index: _index, children: [homePage, checksPage, remindersPage, emergencyPage]);
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (i) {
              final selected = _index == i;
              IconData icon;
              String label;
              switch (i) {
                case 0:
                  icon = Icons.home;
                  label = 'Home';
                  break;
                case 1:
                  icon = Icons.check_box;
                  label = 'Checks';
                  break;
                case 2:
                  icon = Icons.alarm;
                  label = 'Reminders';
                  break;
                default:
                  icon = Icons.call;
                  label = 'Emergency';
              }

              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _index = i),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: selected
                              ? BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(12))
                              : null,
                          child: Icon(icon, color: selected ? Colors.white : Colors.grey[700]),
                        ),
                        const SizedBox(height: 6),
                        Text(label, style: TextStyle(color: selected ? Colors.black87 : Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      floatingActionButton: _index == 2
          ? FloatingActionButton(
              onPressed: () => app.addReminder(Reminder(id: DateTime.now().toIso8601String(), text: 'New reminder')),
              child: const Icon(Icons.add),
            )
          : _index == 3
              ? FloatingActionButton(
                  onPressed: () => app.addContact(Contact(name: 'New Contact', phone: '555-000-0000')),
                  child: const Icon(Icons.add),
                )
              : _index == 1
              ? FloatingActionButton(
                  onPressed: () async {
                    final result = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        final controller = TextEditingController();
                        return AlertDialog(
                          title: const Text('Add room'),
                          content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Room name')),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.of(context).pop(controller.text), child: const Text('Add')),
                          ],
                        );
                      },
                    );
                    if (result != null && result.trim().isNotEmpty) {
                      app.addRoom(result.trim());
                    }
                  },
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
