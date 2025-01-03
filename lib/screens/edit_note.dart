import 'package:doanflutter/providers/note_provider.dart';
import 'package:doanflutter/screens/select_color.dart';
import 'package:flutter/material.dart';
import 'package:doanflutter/models/note.dart';
import 'package:provider/provider.dart';

class EditNotePage extends StatefulWidget {
  final Note note;
  final Function(Note) onSave;

  const EditNotePage({super.key, required this.note, required this.onSave});

  @override
  // ignore: library_private_types_in_public_api
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagsController;
  late TextEditingController _checklistController; 
  List<String> _checklistItems = []; 

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _tagsController = TextEditingController(
        text: widget.note.tags!.join(', ')); 
    if (widget.note.type == 'checklist') {
      _checklistItems = widget.note.checklistItems ??
          []; 
    }
    _checklistController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    if (widget.note.type == 'checklist') {
      _checklistController
          .dispose(); 
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final updatedNote = Note(
                id: widget.note.id,
                title: _titleController.text,
                content: _contentController.text,
                tags: _tagsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .toList(),
                color: widget.note.color,
                type: widget.note.type,
                checklistItems:
                    widget.note.type == 'checklist' ? _checklistItems : null,
              );
              noteProvider.updateNote(
                  widget.note.id, updatedNote);
              Navigator.popUntil(
                  context, ModalRoute.withName('/noteListScreen'));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              if (widget.note.type == 'text') ...[
                const Text(
                  'Content:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _contentController,
                  maxLines: 8, 
                  decoration: const InputDecoration(
                    hintText: 'Enter your content here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16), 
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'Enter tags separated by commas',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'Enter tags separated by commas',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SelectColorDialog(
                          initialColor: noteProvider
                              .getColorForTag(widget.note.tags!.first),
                          tag: widget
                              .note.tags!.first, 
                        );
                      },
                    );
                  },
                  
                  child: const Text('Select Color for Tag'),
                ),
              ],
              if (widget.note.type == 'checklist') ...[
                const Text(
                  'Checklist Items:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ..._checklistItems.map((item) {
                  return ListTile(
                    title: TextFormField(
                      initialValue: item,
                      onChanged: (value) {
                        setState(() {
                          final index = _checklistItems.indexOf(item);
                          _checklistItems[index] = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Checklist item',
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _checklistItems.remove(item);
                        });
                      },
                    ),
                  );
                }).toList(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'Enter tags separated by commas',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SelectColorDialog(
                          initialColor: noteProvider
                              .getColorForTag(widget.note.tags!.first),
                          tag: widget
                              .note.tags!.first, 
                        );
                      },
                    );
                  },
                  
                  child: const Text('Select Color for Tag'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
