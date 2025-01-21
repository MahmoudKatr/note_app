import 'package:flutter/material.dart';
import 'datatbase_helper.dart';

class FavoriteItem extends StatefulWidget {
  const FavoriteItem({super.key});

  @override
  State<FavoriteItem> createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> {
  List<Map<String, dynamic>> favoriteNotes = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteNotes();
  }

  Future<void> fetchFavoriteNotes() async {
    final data = await DBHelper.getFavoriteNotes();
    setState(() {
      favoriteNotes = data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: favoriteNotes.length,
          itemBuilder: (context, index) {
            final note = favoriteNotes[index];
            return Card(
              child: ListTile(
                title: Text(note['title']),
                subtitle: Text(note['note']),
                trailing: const Icon(Icons.favorite, color: Colors.red),
              ),
            );
          },
        ),
      ),
    );
  }
}
