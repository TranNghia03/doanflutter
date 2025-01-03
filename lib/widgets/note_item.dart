import 'package:final2/providers/note_provider.dart';
import 'package:final2/screens/note_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final Function(Note) onUpdate;

  const NoteItem({Key? key, required this.note, required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final backgroundColor = note.tags != null && note.tags!.isNotEmpty
        ? noteProvider.tagColors[note.tags!.first] ?? Colors.grey[200]!
        : const Color.fromARGB(255, 142, 19, 19);

    return Padding(
      padding: const EdgeInsets.all(1),
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailScreen(note: note),
            ),
          );
        },
        child: Card(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: 'note-title-${note.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          note.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        note.isImprotant ? Icons.star : Icons.star_border,
                        color: note.isImprotant ? Colors.yellow : null,
                      ),
                      onPressed: () {
                        final updatedNote = note.copyWith(
                            isImprotant: !note.isImprotant);
                        onUpdate(updatedNote); 
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildNoteContent(note),
                const SizedBox(height: 8),
                if (note.tags!.isNotEmpty)
                  Wrap(
                    spacing: 4, 
                    runSpacing: 2, 
                    children: note.tags!.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 8,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteContent(Note note) {
    switch (note.type) {
      case 'text':
        return Text(note.content ?? 'No content');
      case 'checklist':
        final checklistItems = note.content?.split(',') ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.from(checklistItems.map((item) {
            return Row(
              children: [
                Checkbox(
                  value: note.checklistItems != null &&
                      note.checklistItems!.contains(item),
                  onChanged: (bool? value) {
                    final updatedCheckedItems =
                        List<String>.from(note.checklistItems ?? []);
                    if (value == true) {
                      updatedCheckedItems.add(item);
                    } else {
                      updatedCheckedItems.remove(item);
                    }

                    // Cập nhật ghi chú
                    onUpdate(Note(
                        title: note.title,
                        content: note.content,
                        tags: note.tags,
                        isImprotant: note.isImprotant,
                        id: note.id,
                        type: 'checklist',
                        checklistItems: updatedCheckedItems));
                  },
                ),
                const SizedBox(width: 5),
                Text(item),
              ],
            );
          })),
        );
      case 'image':
        return note.content != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8), 
                child: Image.asset(
                  'assets/images/meo.jpg',
                  width: double.infinity, 
                  height: 200, 
                  fit: BoxFit.cover, 
                ),
              )
            : const Text('No image available');
      case 'event':
        final eventDetails = note.content?.split(',') ?? [];
        final eventDate = eventDetails.isNotEmpty ? eventDetails[0] : 'No date';
        final eventLocation =
            eventDetails.length > 1 ? eventDetails[1] : 'No location';
        return Text('Event on: $eventDate\nLocation: $eventLocation');
      default:
        return const SizedBox.shrink();
    }
  }
}
