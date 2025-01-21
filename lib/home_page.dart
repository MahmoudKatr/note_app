import 'package:flutter/material.dart';
import 'package:note_app/add_notes.dart';
import 'package:note_app/custom_note_item.dart';
import 'package:note_app/datatbase_helper.dart';
import 'package:note_app/favorite_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> notes = [];
  List<bool> isFavorite = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final data = await DBHelper.getDataFromDB();
    print('Fetched data: $data'); // Debug log
    setState(() {
      notes = data ?? [];
      isFavorite = List.generate(
          notes.length, (index) => notes[index]['isFavorite'] == 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.book)),
        title: const Center(child: Text('All Notes')),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoriteItem()));
              },
              icon: const Icon(Icons.favorite)),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                fillColor: Colors.grey[300],
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  print('Building note item: ${notes[index]}'); // Debug log
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: NoteItem(
                      index: index,
                      note: notes[index],
                      isFavorite: isFavorite,
                      onFavoriteToggle: (bool isFav) {
                        setState(() {
                          isFavorite[index] = isFav;
                          final updatedNotes =
                              List<Map<String, dynamic>>.from(notes);
                          updatedNotes[index] = {
                            ...updatedNotes[index], // Copy the original map
                            'isFavorite': isFav ? 1 : 0, // Update the field
                          };
                          notes = updatedNotes;
                          DBHelper.updateFavoriteStatus(
                              notes[index]['id'], isFav);
                        });
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddNotes()));
          },
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
