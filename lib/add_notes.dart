import 'package:flutter/material.dart';
import 'package:note_app/custom_text_field.dart';
import 'package:note_app/datatbase_helper.dart';
import 'package:note_app/home_page.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  _AddNotesState createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _saveNote() async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      await DBHelper.insertDB(title, description);
      print('Note saved: $title, $description');

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title: const Text(
          "Add Notes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _saveNote,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Titles",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            CustomTextField(
              hintText: "Add a New Title",
              controller: _titleController,
            ),
            const Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            CustomTextField(
              hintText: "Add a New Description",
              maxLines: 10,
              controller: _descriptionController,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: FloatingActionButton(
          onPressed: _saveNote,
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
