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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large safety score card
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(child: Text('Safety Score', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text('${(app.overallScore() * 100).round()}%', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text('Needs Attention', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(value: app.overallScore(), minHeight: 12, backgroundColor: Colors.grey.shade300, valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey)),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Rooms Checked:', style: TextStyle(color: Colors.grey.shade700)),
                              Text('${app.rooms.where((r) => r.items.isNotEmpty && r.items.every((i) => i.done)).length} of ${app.rooms.length}', style: TextStyle(color: Colors.grey.shade800)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Two small stat cards
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.home_outlined, size: 28, color: Colors.black87),
                                const SizedBox(height: 8),
                                Text('${app.rooms.length}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text('Rooms', style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_outline, size: 28, color: Colors.green),
                                const SizedBox(height: 8),
                                Text('${app.rooms.expand((r) => r.items).where((i) => i.done).length}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text('Items Safe', style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Start Safety Check button (full width)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => setState(() => _index = 1),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.black87,
                      ),
                      child: const Text('Start Safety Check', style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Safety Tip card
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Center(child: Text('Safety Checklists', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600))),
                const SizedBox(height: 6),
                const Center(child: Text('Check each room in your home', style: TextStyle(color: Colors.grey))),
                const SizedBox(height: 12),

                // Accordion of rooms
                Expanded(
                  child: SingleChildScrollView(
                    child: ExpansionPanelList.radio(
                      elevation: 0,
                      expandedHeaderPadding: EdgeInsets.zero,
                      children: app.rooms.map((room) {
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
                        return ExpansionPanelRadio(
                          value: room.id,
                          headerBuilder: (context, isOpen) {
                            return ListTile(
                              leading: CircleAvatar(backgroundColor: Colors.purple.shade50, child: Icon(icon, color: Colors.purple)),
                              title: Text(room.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(value: progress, minHeight: 10, backgroundColor: Colors.grey.shade300),
                                  ),
                                  const SizedBox(height: 6),
                                  Text('${room.items.where((i) => i.done).length} of ${room.items.length} items', style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            );
                          },
                          body: Column(
                            children: room.items.map((item) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Checkbox(value: item.done, onChanged: (_) => app.toggleItem(room.id, item.id)),
                                    title: Text(item.text),
                                  ),
                                  const Divider(height: 0),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );

          final remindersPage = Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Reminders', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    const Text('Stay on top of safety tasks', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 12),

                    Expanded(
                      child: ListView.builder(
                        itemCount: app.reminders.length,
                        itemBuilder: (context, i) {
                          final r = app.reminders[i];
                          final daysLeft = r.dueDate != null ? r.dueDate!.difference(DateTime.now()).inDays : null;
                          final isDueSoon = daysLeft != null && daysLeft <= 7;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isDueSoon ? Colors.amber.shade300 : Colors.grey.shade200)),
                            color: isDueSoon ? Colors.yellow.shade50 : null,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(r.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                      IconButton(onPressed: () => app.reminders.removeAt(i), icon: Icon(Icons.delete_outline, color: Colors.grey.shade600)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(children: [
                                    Icon(Icons.access_time, color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    Text(r.frequency ?? '', style: TextStyle(color: Colors.grey.shade600)),
                                    const SizedBox(width: 12),
                                    Icon(Icons.calendar_today, color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    Text(r.dueDate != null ? '${r.dueDate!.month}/${r.dueDate!.day}/${r.dueDate!.year}' : '' , style: TextStyle(color: Colors.grey.shade600)),
                                  ]),
                                  if (isDueSoon) ...[
                                    const SizedBox(height: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(color: Colors.yellow.shade100, borderRadius: BorderRadius.circular(8)),
                                      child: Text('Due in ${daysLeft} days', style: TextStyle(color: Colors.grey.shade800)),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                right: 16,
                top: 16,
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]),
                  child: Material(
                    color: Colors.black87,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () async {
                        final result = await showModalBottomSheet<Map<String, String?>>(
                          context: context,
                          isScrollControlled: true,
                          builder: (sheetContext) {
                            final title = TextEditingController();
                            String selectedFreq = 'Weekly';
                            DateTime? selectedDate;
                            return Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
                              child: StatefulBuilder(builder: (context, setState) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      const Text('Add reminder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(sheetContext).pop()),
                                    ]),
                                    TextField(controller: title, decoration: const InputDecoration(hintText: 'Title')),
                                    const SizedBox(height: 12),
                                    Row(children: [
                                      const Text('Frequency:'),
                                      const SizedBox(width: 12),
                                      DropdownButton<String>(
                                        value: selectedFreq,
                                        items: const [
                                          DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                                          DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                                          DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                                          DropdownMenuItem(value: 'Yearly', child: Text('Yearly')),
                                        ],
                                        onChanged: (v) => setState(() => selectedFreq = v ?? 'Weekly'),
                                      ),
                                    ]),
                                    const SizedBox(height: 12),
                                    Row(children: [
                                      const Text('Due date:'),
                                      const SizedBox(width: 12),
                                      TextButton(
                                        onPressed: () async {
                                          final now = DateTime.now();
                                          final picked = await showDatePicker(context: context, initialDate: now, firstDate: DateTime(now.year - 1), lastDate: DateTime(now.year + 5));
                                          if (picked != null) setState(() => selectedDate = picked);
                                        },
                                        child: Text(selectedDate != null ? '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}' : 'Pick date'),
                                      ),
                                    ]),
                                    const SizedBox(height: 12),
                                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                      TextButton(onPressed: () => Navigator.of(sheetContext).pop(), child: const Text('Cancel')),
                                      const SizedBox(width: 12),
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(sheetContext).pop({'title': title.text, 'freq': selectedFreq, 'date': selectedDate?.toIso8601String()}),
                                        child: const Text('Add'),
                                      ),
                                    ]),
                                  ]),
                                );
                              }),
                            );
                          },
                        );
                        if (result != null && (result['title']?.trim().isNotEmpty ?? false)) {
                          DateTime? d;
                          try {
                            final dateStr = result['date'];
                            if (dateStr != null && dateStr.isNotEmpty) d = DateTime.parse(dateStr);
                          } catch (_) {}
                          app.addReminder(Reminder(id: DateTime.now().toIso8601String(), text: result['title']!.trim(), frequency: result['freq'], dueDate: d));
                        }
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          );

          final emergencyPage = Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Emergency', style: TextStyle(fontSize: 34, color: Color.fromARGB(255, 252, 10, 10), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    const Text('Quick access to help', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 18),

                    // Alert card
                    Card(
                      color: Colors.red.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.red.shade200)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: const [
                            Icon(Icons.error_outline),
                            SizedBox(width: 12),
                            Expanded(child: Text('In case of emergency, call 911 immediately', style: TextStyle(fontSize: 16))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 911 card with red call button
                    Card(
                      color: Colors.red.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.red.shade200)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('911 Emergency', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  const Text('Emergency Services', style: TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 8),
                                  const Text('911', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // red call FAB style button on the card
                            Container(
                              decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]),
                              child: Material(
                                color: const Color.fromARGB(255, 249, 7, 7),
                                shape: const CircleBorder(),
                                child: IconButton(
                                  onPressed: () {
                                    // stub: integrate with phone call plugin if desired
                                  },
                                  icon: const Icon(Icons.call, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Contacts list
                    Expanded(
                      child: ListView.builder(
                        itemCount: app.contacts.length,
                        itemBuilder: (context, i) {
                          final c = app.contacts[i];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(c.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 6),
                                        Text(c.role ?? '', style: const TextStyle(color: Colors.grey)),
                                        const SizedBox(height: 8),
                                        Text(c.phone, style: const TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // green call button
                                  Container(
                                    decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))]),
                                    child: Material(
                                      color: Colors.green, // green call
                                      shape: const CircleBorder(),
                                      child: IconButton(
                                        onPressed: () {
                                          // stub: integrate phone call
                                        },
                                        icon: const Icon(Icons.call, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // delete icon
                                  IconButton(
                                    onPressed: () {
                                      app.removeContact(c);
                                    },
                                    icon: Icon(Icons.delete_outline, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // top-right floating add button
              Positioned(
                right: 16,
                top: 16,
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]),
                  child: Material(
                    color: Colors.black87,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () async {
                        final result = await showDialog<Map<String, String>>(
                          context: context,
                          builder: (dialogContext) {
                            final nameCtrl = TextEditingController();
                            final phoneCtrl = TextEditingController();
                            final roleCtrl = TextEditingController();
                            return AlertDialog(
                              title: const Text('Add contact'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Name')),
                                  TextField(controller: roleCtrl, decoration: const InputDecoration(hintText: 'Role (optional)')),
                                  TextField(controller: phoneCtrl, decoration: const InputDecoration(hintText: 'Phone')),
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
                                TextButton(onPressed: () => Navigator.of(dialogContext).pop({'name': nameCtrl.text, 'phone': phoneCtrl.text, 'role': roleCtrl.text}), child: const Text('Add')),
                              ],
                            );
                          },
                        );
                        if (result != null && (result['name']?.trim().isNotEmpty ?? false)) {
                          app.addContact(Contact(name: result['name']!.trim(), phone: result['phone'] ?? '', role: result['role']));
                        }
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
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
                          child: Builder(builder: (context) {
                            // color to green
              final iconColor = selected
                ? (i == 1
                  ? const Color(0xFF24E61A)
                  : (i == 3 ? Colors.redAccent : Colors.white))
                : Colors.grey[700];
                            return Icon(icon, color: iconColor);
                          }),
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
      floatingActionButton: _index == 1
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


