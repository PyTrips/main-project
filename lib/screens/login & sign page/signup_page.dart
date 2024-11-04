import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Home page/Homepage.dart';

void main() {
  runApp(const signup_page());
}

class signup_page extends StatefulWidget {
  const signup_page({super.key});

  @override
  State<signup_page> createState() => _signupPageState();
}

class _signupPageState extends State<signup_page> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _message = '';

  Future<void> _createAccount() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _message = "All fields are required.";
      });
      return;
    }
    if (password.length < 8) {
      setState(() {
        _message = "Password must be at least 8 characters.";
      });
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        _message = "Passwords do not match.";
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        setState(() {
          _message = "Account created successfully!";
        });

        // Navigate to Homepage after account creation
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _message = "Account creation failed. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Opacity(
                  opacity: 1,
                  child: Image.network(
                    "https://media.tripinvites.com/places/puducherry/aayi-mandapam-puducherry/close-view-of-aayi-mandapam-featured.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 280),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Signup', style: TextStyle(fontSize: 25, color: Colors.black)),
                          SizedBox(height: 40),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'User Name',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black38,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black38,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Confirm Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black38,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            obscureText: !_isConfirmPasswordVisible,
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Email',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black38,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _createAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1,
                                vertical: screenHeight * 0.02,
                              ),
                            ),
                            child: const Text(
                              'Create Account',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            _message,
                            style: const TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
