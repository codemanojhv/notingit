import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';

class NoteScreen extends StatefulWidget {
  final String appBarTitle;
  final String docID;

  NoteScreen({Key? key, required this.appBarTitle, required this.docID})
      : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> with WidgetsBindingObserver {
  late TextEditingController textControllers;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    textControllers = TextEditingController();
    fetchData();
    WidgetsBinding.instance!.addObserver(this);
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      await Firebase.initializeApp();
      fetchData();
    }
  }

  Future<void> fetchData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.docID)
        .get();
    setState(() {
      textControllers.text = documentSnapshot['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textControllers,
          maxLines: null, // Allows infinite lines
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Type your note here',
          ),
          onChanged: (value) {
            FirebaseFirestore.instance
                .collection('notes')
                .doc(widget.docID)
                .update({'data': value});
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}