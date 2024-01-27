import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:e_attendance/login.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDrLtvq9pjBa3I5AEuoSVKJUKqy4BjBbKk",
      appId: "1:455710872636:web:601e80d70e1583aa7c9f39",
      messagingSenderId: "455710872636",
      projectId: "elevate-attendance-app",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Elevate Network",
      home: MyLogin(),
      localizationsDelegates:[
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}
