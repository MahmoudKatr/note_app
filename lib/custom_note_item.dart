import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required this.index,
    required this.note,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final int index;
  final Map<String, dynamic> note;
  final List<bool> isFavorite;
  final void Function(bool) onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey[300],
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  note['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  note['note'],
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
              isFavorite[index] ? Icons.favorite : Icons.favorite_border,
              size: 24,
              color: Colors.red,
            ),
            onPressed: () {
              onFavoriteToggle(!isFavorite[index]);
            },
          ),
        ],
      ),
    );
  }
}
