import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notingit/pages/notescreen.dart';
import 'package:notingit/services/firestore.dart';

class HOME extends StatefulWidget {
  const HOME({super.key});

  @override
  State<HOME> createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {
  //firestore
  final firestoreservice = FirestoreServices();

  final textController = TextEditingController();

  // ignore: non_constant_identifier_names
  void OpenNoteBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add Note'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                //buttons
                ElevatedButton(
                  onPressed: () {
                    //add note
                    firestoreservice.createNote(textController.text, textController.text);
                    //clear text box
                    textController.clear();
                    //close text box
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add Note'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[300] ,
          centerTitle: true,
          title: const Text('Noting It',
          
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          )),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: OpenNoteBox, child: const Icon(Icons.add)),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreservice.getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List notesL = snapshot.data!.docs;

              return ListView.builder(
                itemCount: notesL.length,
                itemBuilder: (context, index) {
                  //each doc
                  DocumentSnapshot document = notesL[index];
                  String docID = document.id;

                  //getting note from doc
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteText = data['note']??'empty';

                  //display
                  return ListTile(
                    title: Text(noteText),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NoteScreen(appBarTitle: noteText, docID: docID, )),
                      );
                    },

                    //updatting notes
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                          ),
                          onPressed: () {
                            textController.text = noteText;
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Update Note'),
                                content: TextField(
                                  controller: textController,
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      firestoreservice.updateNote(
                                          docID, textController.text);
                                      textController.clear();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Update Note'),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        //deleting notes
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text('Pakka Delete karoge ?'),
                                actions: [ 
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      firestoreservice.deleteNotes(docID);
                                      Navigator.of(context).pop(); // Close the dialog 
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            //0 notes
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
