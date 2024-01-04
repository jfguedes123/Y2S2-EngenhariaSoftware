import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:formula1/pages/login.dart';
import 'package:formula1/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if the user is already signed in
  final User? user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(
    user: user,
  ));
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: user == null ? const LoginPage() : const WidgetTree(),
    );
  }
}
