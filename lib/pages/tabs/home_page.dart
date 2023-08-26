
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../add_note_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'edit_note_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  Stream<QuerySnapshot<Map<String, dynamic>>> getNotesStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userUid = user.uid;
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('notlar')
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  Future<void> updateNote(
      String noteId, Map<String, dynamic> updatedNote) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userUid = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('notlar')
          .doc(noteId)
          .update(updatedNote);
    }
  }

  Future<void> deleteNote(String noteId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userUid = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('notlar')
          .doc(noteId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 130, 117, 130),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 99, 10, 90),
        title: const Text(
          "User.Me App",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: getNotesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Hata: ${snapshot.error}');
              } else {
                final notes = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      final noteId = note.id;
                      final title = note['title'];
                      final description = note['description'];
                      final timestamp = note['timestamp'].toDate();

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ExpansionTile(
                            title: Text(title),
                            subtitle: Text(
                              "Date: ${DateFormat('dd.MM.yyyy HH:mm').format(timestamp)}",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(description),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final updatedNote =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditNoteScreen(
                                                    note: const {},
                                                  )),
                                        );

                                        if (updatedNote != null) {
                                          await updateNote(noteId, updatedNote);
                                        }
                                      },
                                      child: const Text(
                                        "Update Note",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final confirm = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                              "Notu Sil",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                            content: const Text(
                                              "Are you sure you want to delete this note?",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0)),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          await deleteNote(noteId);
                                        }
                                      },
                                      child: const Text(
                                        "Delete Note",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),

        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton.filled(
                iconSize: 76,
                icon: const Icon(Icons.add, color: Colors.white),
                style: IconButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 99, 10, 90)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddNoteScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }


}
