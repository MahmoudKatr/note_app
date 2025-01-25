import 'package:flutter/material.dart';
import 'package:note_app/datatbase_helper.dart';
import 'themes.dart'; // Import the AppThemes class
import 'home_page.dart'; // Import the HomePage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.createDB();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme,
      home: HomePage(onThemeToggle: toggleTheme),
    );
  }
}
