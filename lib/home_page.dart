import 'package:flutter/material.dart';
import 'package:note_app/add_notes.dart';
import 'package:note_app/archives_item.dart';
import 'package:note_app/custom_note_item.dart';
import 'package:note_app/datatbase_helper.dart';
import 'package:note_app/edit_note_view.dart';
import 'package:note_app/favorite_item.dart';
import 'package:note_app/theme_provider.dart';
import 'package:provider/provider.dart';

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
    try {
      final data = await DBHelper.getDataFromDB();
      print('Fetched data: $data'); // Debug log
      setState(() {
        notes =
            List<Map<String, dynamic>>.from(data ?? []); // Ensure mutability
        isFavorite = List.generate(
          notes.length,
          (index) => notes[index]['isFavorite'] == 1,
        );
      });
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ArchivesItemView()),
            );
          },
          icon: const Icon(Icons.archive),
        ),
        title: const Center(child: Text('All Notes')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteItem()),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                hintText: "Search",
                hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white // Example for light hint text in dark mode
                      : Colors
                          .black, // Example for dark hint text in light mode
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (query) async {
                if (query.isEmpty) {
                  await fetchNotes();
                } else {
                  final searchResults = await DBHelper.searchNotes(query);
                  setState(() {
                    notes = searchResults;
                  });
                }
              },
            ),
            const SizedBox(
              height: 40.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Dismissible(
                      key: ValueKey(notes[index]['id']),
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Row(
                          children: [
                            Icon(Icons.archive, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Archive",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Delete",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.delete, color: Colors.white),
                          ],
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        if (notes[index]['isFavorite'] == 1) {
                          // Show a SnackBar and block dismissal for favorite notes
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Favorite notes cannot be archived or deleted."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return false; // Prevent dismissal
                        }
                        return true; // Allow dismissal for non-favorite notes
                      },
                      onDismissed: (direction) {
                        final dismissedNote = notes[index];

                        setState(() {
                          notes
                              .removeAt(index); // Remove the item from the list
                        });

                        if (direction == DismissDirection.endToStart) {
                          // Delete the note
                          DBHelper.deleteNote(dismissedNote['id'])
                              .catchError((error) {
                            print("Error deleting note: $error");
                            setState(() {
                              notes.insert(index, dismissedNote);
                            });
                          });
                        } else if (direction == DismissDirection.startToEnd) {
                          // Archive the note
                          DBHelper.updateNoteStatus(dismissedNote['id'], true)
                              .catchError((error) {
                            print("Error archiving note: $error");
                            setState(() {
                              notes.insert(index, dismissedNote);
                            });
                          });
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: NoteItem(
                          index: index,
                          note: notes[index],
                          isFavorite: notes[index]['isFavorite'] ==
                              1, // Check if the value is 1
                          onFavoriteToggle: (bool isFav) async {
                            setState(() {
                              // Create a mutable copy of the note and update its 'isFavorite' value
                              final updatedNote =
                                  Map<String, dynamic>.from(notes[index]);
                              updatedNote['isFavorite'] = isFav ? 1 : 0;

                              // Replace the original note in the list with the updated note
                              notes[index] = updatedNote;
                            });

                            // Update the favorite status in the database
                            await DBHelper.updateFavoriteStatus(
                              notes[index]['id'], // Pass the note ID
                              isFav
                                  ? 1
                                  : 0, // Convert bool to int for the database
                            );
                          },
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditNoteView(noteID: notes[index]['id'])),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddNotes()),
            );
          },
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white // Example for light hint text in dark mode
              : Colors.black,
          child: Icon(
            Icons.add,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black // Example for light hint text in dark mode
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
