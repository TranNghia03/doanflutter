import 'package:final2/models/note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import 'add_note_screen.dart';
import '../widgets/note_item.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Note> _filteredNotes = [];
  String _selectedTag = ''; // Biến lưu thẻ đã chọn
  bool _isGridView = false; // Biến để kiểm tra chế độ hiển thị (dọc hoặc ngang)

  @override
  void initState() {
    super.initState();
    _filteredNotes =
        Provider.of<NoteProvider>(context, listen: false).notes.cast<Note>();
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<NoteProvider>(context).notes;

    // Sắp xếp ghi chú theo mức độ quan trọng
    _filteredNotes.sort((a, b) {
      if (a.isImprotant && !b.isImprotant) return -1;
      if (!a.isImprotant && b.isImprotant) return 1;
      return 0;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              _showFilterDialog(notes); // Hiển thị dialog lọc thẻ
            },
          ),
          IconButton(
            icon: Icon(_isGridView
                ? Icons.view_list
                : Icons.grid_on), // Icon thay đổi tùy theo chế độ
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView; // Chuyển đổi chế độ hiển thị
              });
            },
          ),
        ],
      ),
      body: _filteredNotes.isEmpty
          ? const Center(child: Text('No notes available.'))
          : AnimatedSwitcher(
              duration:
                  const Duration(milliseconds: 1000), // Thời gian hiệu ứng
              child: _isGridView
                  ? GridView.builder(
                      key: const ValueKey(
                          'gridView'), // Thêm key để AnimatedSwitcher nhận diện
                      // ignore: prefer_const_constructors
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Chế độ lưới 2 cột
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _filteredNotes.length,
                      itemBuilder: (context, index) {
                        return NoteItem(
                          note: _filteredNotes[index],
                          onUpdate: (updatedNote) {
                            setState(() {
                              _filteredNotes[index] = updatedNote;
                              final originalIndex = notes.indexWhere((note) =>
                                  note.id == _filteredNotes[index].id);
                              if (originalIndex != -1) {
                                notes[originalIndex] = updatedNote;
                              }
                            });
                          },
                        );
                      },
                    )
                  : ListView.builder(
                      key: const ValueKey(
                          'listView'), // Thêm key để AnimatedSwitcher nhận diện
                      itemCount: _filteredNotes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: NoteItem(
                            note: _filteredNotes[index],
                            onUpdate: (updatedNote) {
                              setState(() {
                                _filteredNotes[index] = updatedNote;
                                final originalIndex = notes.indexWhere((note) =>
                                    note.id == _filteredNotes[index].id);
                                if (originalIndex != -1) {
                                  notes[originalIndex] = updatedNote;
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Hiển thị hộp thoại tìm kiếm
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Notes'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Search by title'),
            onChanged: _filterNotes,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _searchController.clear();
                _filterNotes(''); // Reset filter
                Navigator.pop(context);
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Lọc danh sách ghi chú theo từ khóa
  void _filterNotes(String query) {
    final notes = Provider.of<NoteProvider>(context, listen: false).notes;

    setState(() {
      _filteredNotes = notes
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) &&
              (_selectedTag.isEmpty || note.tags!.contains(_selectedTag)))
          .toList();
    });
  }

  // Hiển thị hộp thoại lọc theo thẻ
  void _showFilterDialog(List<Note> notes) {
    final tags = _getTagsFromNotes(notes);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter by Tag'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...tags.map((tag) {
                return RadioListTile<String>(
                  title: Text(tag),
                  value: tag,
                  groupValue: _selectedTag,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedTag = value!;
                      _filterNotes(
                          _searchController.text); // Re-filter based on search
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedTag = '';
                    _filterNotes(
                        _searchController.text); // Re-filter based on search
                  });
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        );
      },
    );
  }

  List<String> _getTagsFromNotes(List<Note> notes) {
    Set<String> tags = {};

    for (var note in notes) {
      note.tags?.forEach((tag) {
        tags.add(tag);
      });
    }
    return tags.toList();
  }
}
