import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:doanflutter/providers/note_provider.dart';

class SelectColorDialog extends StatefulWidget {
  final Color initialColor;
  final String tag;
  const SelectColorDialog({
    super.key,
    required this.initialColor,
    required this.tag,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SelectColorDialogState createState() => _SelectColorDialogState();
}

class _SelectColorDialogState extends State<SelectColorDialog> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a Color'),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: selectedColor,
          onColorChanged: (color) {
            setState(() {
              selectedColor = color;
            });
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final noteProvider = Provider.of<NoteProvider>(context, listen: false);
            noteProvider.setColorForTag(widget.tag, selectedColor);
            Navigator.of(context).pop();
          },
          child: const Text('Select'),
        ),
      ],
    );
  }
}
