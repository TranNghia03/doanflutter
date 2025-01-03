import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;

  const AddNoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _tagsController;
  String _noteType = 'text';
  List<String> _checklistItems = [];
  String? _selectedColor;
  DateTime? _eventDate;
  String? _eventLocation;
  String? _textContent;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      final note = widget.note!;
      _noteType = note.type;
      _titleController = TextEditingController(text: note.title);
      _tagsController = TextEditingController(text: note.tags?.join(',') ?? '');
      _selectedColor = note.color;
      _textContent = note.type == 'text' ? note.content : null;
      _checklistItems = note.type == 'checklist'
          ? (note.content?.split(',') ?? [])
          : [];
      _imagePath = note.type == 'image' ? note.content : null;
      if (note.type == 'event') {
        final parts = note.content?.split(',') ?? [];
        _eventDate = parts.isNotEmpty ? DateTime.tryParse(parts[0]) : null;
        _eventLocation = parts.length > 1 ? parts[1] : null;
      }
    } else {
      _titleController = TextEditingController();
      _tagsController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.note == null ? 'Add Note' : 'Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              DropdownButton<String>(
                value: _noteType,
                onChanged: (value) {
                  setState(() {
                    _noteType = value!;
                  });
                },
                items: const [
                  DropdownMenuItem(value: 'text', child: Text('Text')),
                  DropdownMenuItem(value: 'checklist', child: Text('Checklist')),
                  DropdownMenuItem(value: 'image', child: Text('Image')),
                  DropdownMenuItem(value: 'event', child: Text('Event')),
                ],
              ),
              const SizedBox(height: 16),
              _buildContentSection(),
              TextField(
                controller: _tagsController,
                decoration: const InputDecoration(labelText: 'Tags'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveNote,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    switch (_noteType) {
      case 'text':
        return TextField(
          decoration: const InputDecoration(labelText: 'Text Content'),
          maxLines: null,
          onChanged: (value) => _textContent = value,
          controller: TextEditingController(text: _textContent),
        );
      case 'checklist':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._checklistItems
                .asMap()
                .entries
                .map((entry) => _buildChecklistItem(entry.key, entry.value))
                .toList(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _checklistItems.add('');
                });
              },
              child: const Text('Add Item'),
            ),
          ],
        );
      case 'image':
        return Column(
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Choose Image'),
            ),
            if (_imagePath != null)
              Image.asset(
                _imagePath!,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
          ],
        );
      case 'event':
        return Column(
          children: [
            ListTile(
              title: const Text('Event Date and Time'),
              subtitle: Text(_eventDate != null
                  ? DateFormat('yyyy-MM-dd HH:mm').format(_eventDate!)
                  : 'Select a date and time'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickEventDate,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Location'),
              onChanged: (value) => _eventLocation = value,
              controller: TextEditingController(text: _eventLocation),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildChecklistItem(int index, String value) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(labelText: 'Checklist Item'),
            onChanged: (val) {
              setState(() {
                _checklistItems[index] = val;
              });
            },
            controller: TextEditingController(text: value),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            setState(() {
              _checklistItems.removeAt(index);
            });
          },
        ),
      ],
    );
  }

  void _pickImage() {
    setState(() {
      _imagePath = 'assets/images/meo.jpg';
    });
  }

  void _pickEventDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      final selectedTime = await _pickEventTime();
      if (selectedTime != null) {
        setState(() {
          _eventDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  Future<TimeOfDay?> _pickEventTime() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return selectedTime;
  }

  void _saveNote() {
    final newNote = Note(
      id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      type: _noteType,
      color: _selectedColor,
      tags: _tagsController.text.split(','),
      checklistItems: _noteType == 'checklist' ?_checklistItems: null,
      content: _getContentBasedOnType(),
    );

    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    if (widget.note == null) {
      noteProvider.addNote(newNote);
    } else {
      noteProvider.updateNote(newNote.id, newNote);
    }
    Navigator.pop(context);
  }

  String? _getContentBasedOnType() {
    switch (_noteType) {
      case 'text':
        return _textContent;
      case 'checklist':
        return _checklistItems.join(',');
      case 'image':
        return _imagePath;
      case 'event':
        return 'Date: $_eventDate, $_eventLocation';
      default:
        return null;
    }
  }
}
