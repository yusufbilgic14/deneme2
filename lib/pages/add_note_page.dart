import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  final user = FirebaseAuth.instance.currentUser;

  void _addNoteToFirestore() async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userUid = user.uid;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .collection('notlar')
            .add({
          'title': title,
          'description': description,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }

      Navigator.pop(context);
    } catch (error) {
      log('Hata: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 130, 117, 130),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 10, 90),
        title: const Text(
          'New Note',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Title of The Note',
                  
                  hintStyle: TextStyle(color: Colors.white)),
              controller: _titleController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Description of The Note',
                  hintStyle: TextStyle(color: Colors.white)),
              controller: _descriptionController,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addNoteToFirestore,
              child: const Text('Not Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
