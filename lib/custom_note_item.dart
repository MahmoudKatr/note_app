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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black // Example for light hint text in dark mode
              : Colors.white,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white // Example for light hint text in dark mode
                : Colors.black,
          ),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors
                              .white // Example for light hint text in dark mode
                          : Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      note['note'] ?? 'No Content',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors
                                .white // Example for light hint text in dark mode
                            : Colors.black,
                      ),
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
                color: isFavorite
                    ? Colors.red
                    : const Color.fromARGB(
                        255, 98, 86, 86), // Highlight favorite
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
