import 'package:flutter/material.dart';
import 'package:note_app/custom_text_field.dart';
import 'package:note_app/datatbase_helper.dart';
import 'package:note_app/home_page.dart';

class EditNoteView extends StatefulWidget {
  const EditNoteView({super.key, required this.noteID});
  final int noteID;

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNoteData();
  }

  Future<void> fetchNoteData() async {
    try {
      final note = await DBHelper.getNoteById(widget.noteID);
      if (note != null) {
        setState(() {
          titleController.text = note['title'] ?? '';
          descriptionController.text = note['note'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching note data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black // Example for light hint text in dark mode
            : Colors.white,
        title: const Text(
          "Add Notes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Titles",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            CustomTextField(
              controller: titleController,
              hintText: "Add a New Title",
            ),
            const Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            CustomTextField(
              controller: descriptionController,
              hintText: "Add a New Description",
              maxLines: 10,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: FloatingActionButton(
          onPressed: () async {
            await DBHelper.updateNote(widget.noteID, titleController.text,
                descriptionController.text);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white // Example for light hint text in dark mode
              : Colors.black,
          child: Icon(
            Icons.edit,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black // Example for light hint text in dark mode
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
