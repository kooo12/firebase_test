import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_test/home.dart';
import 'package:firebase_test/login_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.dark()),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: StreamBuilder<User?>(
        stream: _isLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          User? user = snapshot.data;
          if (user == null) {
            return const LoginScreen();
          }
          return const Home();
        },
      )),
    );
  }

  Stream<User?> _isLogin() {
    return FirebaseAuth.instance.authStateChanges();
  }
}
