import'package:flutter/material.dart';

void main(){
  runApp(Favorite_page());
}

class Favorite_page extends StatefulWidget {
  const Favorite_page({super.key});

  @override
  State<Favorite_page> createState() => _myappState();
}

class _myappState extends State<Favorite_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:Text('hello')),
    );
  }
}
