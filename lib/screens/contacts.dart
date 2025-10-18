import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../models/models.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: app.contacts.map((c) => ListTile(
            title: Text(c.name),
            subtitle: Text(c.phone),
            trailing: IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {
                // In a real app we'd use url_launcher to call; here it's a stub
              },
            ),
          )).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // stub add contact
          app.addContact(Contact(name: 'New Contact', phone: '555-000-0000'));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
