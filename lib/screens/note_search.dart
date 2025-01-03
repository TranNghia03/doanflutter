import 'package:flutter/material.dart';

class NoteSearch extends StatefulWidget {
  @override
  _NoteSearchState createState() => _NoteSearchState();
}

class _NoteSearchState extends State<NoteSearch> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _notes = [];
  List<String> _filteredNotes = [];

  @override
  void initState() {
    super.initState();
    _filteredNotes = _notes;
  }

  void _filterNotes(String query) {
    setState(() {
      _filteredNotes = _notes
          .where((note) => note.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Search Notes",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterNotes,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredNotes[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: NoteSearch(),
    ));
