import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  final List<Note> _notes = [
    Note(
        title: 'First Note',
        tags: ['work'],
        id: UniqueKey().toString(),
        type: 'text',
        content: 'This is first note'),
    Note(
        title: 'Second Note',
        tags: ['work'],
        id: UniqueKey().toString(),
        type: 'text',
        content: 'This is second note'),
    Note(
        title: 'Third Note',
        tags: ['personal'],
        id: UniqueKey().toString(),
        type: 'text',
        content: 'This is third note'),
    Note(
        title: 'Four Note',
        tags: ['work'],
        id: UniqueKey().toString(),
        type: 'text',
        content: 'This is four note'),
    Note(
        title: 'Five Note',
        tags: ['personal'],
        id: UniqueKey().toString(),
        type: 'text',
        content: 'This is five note'),
  ];

  final Map<String, Color> _tagColors = {};
  Map<String, Color> get tagColors => _tagColors;
  List<Note> get notes => _notes;
  

  Color getColorForTag(String tag) {
    if (tag.isEmpty) {
    return Colors.grey.withOpacity(0.7);
    }
    if (!_tagColors.containsKey(tag)) {
      _tagColors[tag] = Colors.primaries[_tagColors.length % Colors.primaries.length]
          .withOpacity(0.7);
    }
    return _tagColors[tag]!;
  }
  void addNote(Note note) {
    _notes.add(note);
    note.tags?.forEach((tag) {
      getColorForTag(tag); // Sử dụng phương thức công khai để lấy màu
    });
    notifyListeners();
  }

  void updateNote(String id, Note updatedNote) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = updatedNote;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  List<Note> searchNotes(String query) {
    return _notes
        .where((note) => note.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Note> filterNotesByTag(String tag) {
    return _notes.where((note) => note.tags?.contains(tag) ?? false).toList();
  }
  void setColorForTag(String tag, Color color) {
    _tagColors[tag] = color;
    notifyListeners();
  }
}
