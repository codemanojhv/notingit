import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notingit/firebase_options.dart';
import 'package:notingit/pages/home.dart';

import 'pages/notescreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      routes: {
    '/': (context) => const HOME(),
    '/note': (context) => NoteScreen(appBarTitle: 'Edit Note', docID: '')
    // Add more routes as needed
  },
      debugShowCheckedModeBanner: false,
    
    );
  }
}