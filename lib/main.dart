import 'package:flutter/material.dart';
import 'package:note_app/datatbase_helper.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.createDB();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(ThemeData.light()), // Default to light theme
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          home: const HomePage(),
        );
      },
    );
  }
}
