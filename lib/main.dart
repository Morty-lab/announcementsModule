import 'package:final_project/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core

void main() async { // Make main asynchronous
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ); // Initialize Firebase
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SidebarXExampleApp(),
    );
  }
}
