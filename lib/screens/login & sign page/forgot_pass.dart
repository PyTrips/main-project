import 'package:final_yearproject/screens/login%20&%20sign%20page/reset_pass.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ForgottenPasswordActivity extends StatelessWidget {
  const ForgottenPasswordActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    Future<dynamic> handleNextBtn() {
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const reset_pass()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: const TextStyle(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your email address',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email id',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text.trim();
                  if (email.isNotEmpty) {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                      // Navigate to reset password screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const reset_pass()),
                      );
                      // Show a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password reset email sent! Check your inbox.')),
                      );
                    } on FirebaseAuthException catch (e) {
                      // Handle errors
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.message ?? 'An error occurred')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter your email')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0), // Full-width button
                ),
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
