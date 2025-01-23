import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  const NoteItem(
      {super.key,
      required this.index,
      required this.note,
      required this.isFavorite,
      required this.onFavoriteToggle,
      required this.onTap});
  final void Function()? onTap;
  final int index;
  final Map<String, dynamic> note;
  final bool isFavorite; // Change from List<bool> to a single bool
  final void Function(bool) onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[300],
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the left
                children: [
                  Text(
                    note['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    note['note'] ?? 'No Content',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 134, 127, 127),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border, // Use single bool
                size: 24,
                color:
                    isFavorite ? Colors.red : Colors.grey, // Highlight favorite
              ),
              onPressed: () {
                onFavoriteToggle(!isFavorite); // Toggle favorite
              },
            ),
          ],
        ),
      ),
    );
  }
}
