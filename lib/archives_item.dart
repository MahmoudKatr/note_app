import 'package:flutter/material.dart';

import 'datatbase_helper.dart';

class ArchivesItemView extends StatefulWidget {
  const ArchivesItemView({super.key});

  @override
  State<ArchivesItemView> createState() => _ArchivesItemViewState();
}

class _ArchivesItemViewState extends State<ArchivesItemView> {
  List<Map<String, dynamic>> archivedNotes = [];

  @override
  void initState() {
    super.initState();
    loadArchivedNotes();
  }

  Future<void> loadArchivedNotes() async {
    try {
      final data = await DBHelper.getArchivedNotes(); // Fetch archived notes
      setState(() {
        archivedNotes = List<Map<String, dynamic>>.from(data ?? []);
      });
    } catch (e) {
      print('Error loading archived notes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: archivedNotes.isEmpty
            ? const Center(
                child: Text(
                  'No archived notes available.',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: archivedNotes.length,
                itemBuilder: (context, index) {
                  final note = archivedNotes[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        note['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(note['note'] ?? 'No Content'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteArchivedNote(index, note['id']),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void deleteArchivedNote(int index, int noteId) async {
    try {
      await DBHelper.deleteNote(noteId); // Delete note from database
      setState(() {
        archivedNotes.removeAt(index); // Remove from the list
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted successfully')),
      );
    } catch (e) {
      print('Error deleting note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete note')),
      );
    }
  }
}
