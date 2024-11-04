import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login & sign page/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // Sign-out method
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();

    _scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('Successfully signed out!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back to the login page after a brief delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) =>  login_page()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _signOut,
              tooltip: 'Sign Out',
            ),
          ],
        ),
        body: const Center(
          child: Text('Welcome to the Home Page!'),
        ),
      ),
    );
  }
}
