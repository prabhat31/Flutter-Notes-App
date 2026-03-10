import 'package:flutter/material.dart';
import '../data/local/db_helper.dart';
import '../widgets/note_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  final Function toggleTheme;
  final bool darkMode;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.darkMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper db = DBHelper.getInstance;

  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> filteredNotes = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void loadNotes() async {
    notes = await db.getAllNotes();
    filteredNotes = notes;
    setState(() {});
  }

  void searchNotes(String query) {
    filteredNotes = notes.where((note) {
      return note[DBHelper.COLUMN_NOTE_TITLE].toLowerCase().contains(
        query.toLowerCase(),
      );
    }).toList();

    setState(() {});
  }

  void deleteNote(int id) async {
    await db.deleteNote(id);
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
        actions: [
          IconButton(
            onPressed: () {
              widget.toggleTheme();
            },
            icon: Icon(widget.darkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              onChanged: searchNotes,
              decoration: const InputDecoration(
                hintText: "Search notes",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: filteredNotes.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (_, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            filteredNotes[index][DBHelper.COLUMN_NOTE_TITLE],
                          ),
                          subtitle: Text(
                            filteredNotes[index][DBHelper.COLUMN_NOTE_DESC],
                          ),

                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deleteNote(
                                filteredNotes[index][DBHelper.COLUMN_NOTE_SNO],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text("No Notes")),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) {
              return NoteBottomSheet(onNoteAdded: loadNotes);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
