import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  //get
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  //c
  Future<void> createNote(String note, String data) async {
    await notes.add({
      'note': note,
      'data': data,
      'timestamp': Timestamp.now(),
    });
  }

 Future<void> updatseNote(String docID, String newData) async {
    await notes.doc(docID).update({
      'data': newData,
     
      'timestamp': Timestamp.now(), 
      
    });
  }

  ///r

  Stream<QuerySnapshot> getNotesStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }


    Stream<QuerySnapshot> getDataStream() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  //u
  Future<void> updateNote(String docID, String newNote) async {
    await notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(), 
      
    });
  }

  //d

  Future<void> deleteNotes(String docID) async {
    await notes.doc(docID).delete();
  }
}
