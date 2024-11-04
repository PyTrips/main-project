import 'package:final_yearproject/screens/login%20&%20sign%20page/reset_pass.dart';
import 'package:final_yearproject/screens/login%20&%20sign%20page/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Home page/Homepage.dart';

class login_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool textVisible = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(BuildContext context) async {
    await _googleSignIn.signOut();
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
        .signIn();

    if (googleSignInAccount == null) {
      _showErrorMessage("Google Sign-In aborted");
      return; // Handle sign-in cancellation
    }

    try {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
          .authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      print(userCredential.user!.displayName);
      print(userCredential.user!.email);
      print(userCredential.user!.metadata);

      _showSuccessMessage("Login successful!");


      await Future.delayed(Duration(seconds: 2));


      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Homepage()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      _showErrorMessage("Google Sign-In failed. Please try again.");
    }
  }

  void _showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      duration: const Duration(seconds: 2),
      elevation: 0,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      duration: const Duration(seconds: 2),
      elevation: 0,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  void _login() async {
    String loginId = _loginIdController.text.trim();
    String password = _passwordController.text.trim();

    if (loginId.isEmpty || password.isEmpty) {
      _showErrorMessage(loginId.isEmpty && password.isEmpty
          ? 'Login ID and Password are required.'
          : loginId.isEmpty
          ? 'Login ID is required.'
          : 'Password is required.');
    } else {
      try {

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: loginId, password: password);


        _showSuccessMessage("Login successful!");

        await Future.delayed(
            Duration(seconds: 2));


        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
              (Route<dynamic> route) => false,
        );
      } catch (e) {
        _showErrorMessage("Incorrect login Id or Password");
      }
    }
  }

  Future<void> _register() async {
    String loginId = _loginIdController.text.trim();
    String password = _passwordController.text.trim();

    if (loginId.isEmpty || password.isEmpty) {
      _showErrorMessage(loginId.isEmpty && password.isEmpty
          ? 'Login ID and Password are required.'
          : loginId.isEmpty
          ? 'Login ID is required.'
          : 'Password is required.');
    } else {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: loginId, password: password);

        _showSuccessMessage("Registration successful! Please log in.");
      } catch (e) {
        _showErrorMessage("Registration failed. Please try again.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return
       Scaffold(
        resizeToAvoidBottomInset: true,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.055),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://www.shutterstock.com/image-vector/pondicherry-puducherry-india-quay-beach-600nw-1109835314.jpg',
                    height: screenHeight * 0.45,
                    width: screenWidth * 0.85,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Column(
                  children: [
                    TextField(
                      controller: _loginIdController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black38,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextField(
                      controller: _passwordController,
                      obscureText: !textVisible,
                      cursorColor: Colors.black38,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              textVisible = !textVisible;
                            });
                          },
                          icon: Icon(
                            textVisible ? Icons.visibility : Icons
                                .visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black38,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.0005),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Check if the email field is empty
                          if (_loginIdController.text.trim().isEmpty) {
                            // Display error message if email is empty
                            _showErrorMessage('Email is not filled');
                          } else {
                            // Navigate to the reset password page if email is filled
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => reset_pass()),
                            );
                          }
                        },
                        child: const Text(
                          'Forget Password',
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.3,
                          vertical: screenHeight * 0.02,
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, (MaterialPageRoute(
                                builder: (context) => signup_page())));
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'or login with',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ElevatedButton.icon(
                      onPressed: () => signInWithGoogle(context),
                      icon: const Icon(Icons.g_mobiledata, color: Colors.green,),
                      label: const Text('Sign in with Google',style: TextStyle(color: Colors.green),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey[100],
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1,
                          vertical: screenHeight * 0.015,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
    );
  }
}
