import 'dart:async';
import 'package:final_yearproject/screens/Home%20page/Homepage.dart';
import 'package:final_yearproject/screens/login%20&%20sign%20page/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Timer(Duration(seconds: 5), () {
      _navigateToNextPage();
    });
  }

  void _navigateToNextPage() async {
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      print("Error checking user authentication: $e");
    }

    if (user != null) {
      // User is signed in, navigate to the homepage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    } else {

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => login_page()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(seconds: 3), // Fade-in duration
          child: Image.asset(
            'assets/pondicherry-Banner-Text.png',
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),

    );
  }
}
