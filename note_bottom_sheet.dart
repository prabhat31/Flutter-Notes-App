import 'package:flutter/material.dart';
import '../data/local/db_helper.dart';

class NoteBottomSheet extends StatefulWidget {
  final Function onNoteAdded;

  const NoteBottomSheet({super.key, required this.onNoteAdded});

  @override
  State<NoteBottomSheet> createState() => _NoteBottomSheetState();
}

class _NoteBottomSheetState extends State<NoteBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DBHelper db = DBHelper.getInstance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add Note",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: "Title",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: descController,
            decoration: const InputDecoration(
              hintText: "Description",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () async {
              await db.addNote(
                title: titleController.text,
                desc: descController.text,
              );

              widget.onNoteAdded();

              Navigator.pop(context);
            },

            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
