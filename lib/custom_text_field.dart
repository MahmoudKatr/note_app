import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    this.onSaved,
    this.onChange,
    this.controller,
    this.borderColor = Colors.grey,
  }); // Added borderColor parameter

  final String hintText;
  final TextEditingController? controller;
  final int maxLines;
  final void Function(String?)? onSaved;
  final void Function(String)? onChange;
  final Color borderColor; // Added borderColor property

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            onChanged: onChange,
            onSaved: onSaved,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Field cannot be empty';
              } else {
                return null;
              }
            },
            cursorColor: Colors.black,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              border: buildBorder(borderColor),
              enabledBorder: buildBorder(borderColor),
              focusedBorder: buildBorder(Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color), // Use color parameter
    );
  }
}
