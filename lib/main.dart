import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';
import 'screens/note_list_screen.dart';
import 'screens/add_note_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Notes',
      initialRoute: '/noteListScreen', 
      routes: {
        '/noteListScreen': (context) => const NoteListScreen(), 
        '/addNoteScreen': (context) => const AddNoteScreen(), 
      },
    );
  }
}
