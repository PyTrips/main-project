import'package:flutter/material.dart';

void main(){
  runApp(Profile_page());
}

class Profile_page extends StatefulWidget {
  const Profile_page({super.key});

  @override
  State<Profile_page> createState() => _myappState();
}

class _myappState extends State<Profile_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('profile page')),
    );
  }
}