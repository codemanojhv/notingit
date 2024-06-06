
import 'package:flutter/material.dart';
import 'package:notingit/services/firestore.dart';

class NoteScreen extends StatelessWidget {
  final String appBarTitle;
    final String docID;
  final TextEditingController textControllers = TextEditingController();

NoteScreen({super.key, required this.appBarTitle, required this.docID});

  @override
  Widget build(BuildContext context) {
      final firestoreservice = FirestoreServices();
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: 
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textControllers,
              maxLines: null, // Allows infinite lines
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Type your note here',
              ),
            ),
          ),
         
        

      floatingActionButton: FloatingActionButton(
        onPressed: () {
         firestoreservice.updatseNote(docID, textControllers.text );
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save),
      ), 


    );
  }
}