import 'package:doanflutter/screens/edit_note.dart';
import 'package:flutter/material.dart';
import 'package:doanflutter/models/note.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final note = widget.note;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNotePage(
                    note: note,
                    onSave: (updatedNote) {
                      Provider.of<NoteProvider>(context, listen: false)
                          .updateNote(note.id, updatedNote);
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Delete Note"),
                    content: const Text(
                        "Are you sure you want to delete this note?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<NoteProvider>(context, listen: false)
                              .deleteNote(note.id);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (note.type == 'text') ...[
                      Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 1.5, color: Colors.grey),
                      const SizedBox(height: 5),
                      Text(
                        note.content ?? 'No content available',
                        style: const TextStyle(
                            fontSize: 26, color: Colors.black54),
                      ),
                      const SizedBox(height: 26),
                      const SizedBox(height: 20),
                      if (note.color != null)
                        Row(
                          children: [
                            const Text(
                              'Color: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(int.parse(note.color!, radix: 16)),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              note.tags?.join(', ') ?? 'No tags',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (note.type == 'checklist' &&
                        note.checklistItems != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 1.5, color: Colors.grey),
                      const SizedBox(height: 5),
                      const Text(
                        'Checklist Items:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...note.checklistItems!.map((item) => Row(
                            children: [
                              const Icon(Icons.check_box_outline_blank,
                                  size: 18),
                              const SizedBox(width: 8),
                              Text(
                                item,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          )),
                      // const SizedBox(height: 16),
                      const SizedBox(height: 20),
                      if (note.color != null)
                        Row(
                          children: [
                            const Text(
                              'Color: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Color(int.parse(note.color!, radix: 16)),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              note.tags?.join(', ') ?? 'No tags',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (note.type == 'image' && note.imagePath != null) ...[
                      Image.asset(
                        'assets/images/meo.jpg',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
