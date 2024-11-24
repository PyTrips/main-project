import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminPage(),
    );
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final ImagePicker picker = ImagePicker();
  List<File> _images = [];
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
        });
        print("Picked images: $_images");
      } else {
        print("No images selected.");
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }


  Widget _buildImageContainerFromFile(File file) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: FileImage(file),
          fit: BoxFit.cover,
        ),
      ),
    );
  }


  void _signOut() {
    print("Sign out clicked");
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Text(
                            'Hi Admin',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.admin_panel_settings,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 145),
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Image.asset('assets/path-removebg-preview.png'),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.2),
                        IconButton(
                          onPressed: () {
                            _signOut();
                          },
                          icon: const Icon(Icons.notifications_none),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Text(
                            'Manage ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'PUDUCHERRY',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Center(
                child: SizedBox(
                  height: 190,
                  width: 400,
                  child: PageView(
                    controller: _pageController,
                    children: _images.isEmpty
                        ? [
                      _buildImageContainerFromFile(File('https://www.agoda.com/wp-content/uploads/2024/04/Featured-image-Pondicherry-India.jpg')),
                      _buildImageContainerFromFile(File('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVFeKW8s_C8HEh9PAwuZQSDE0-F8ZH2SD36VK-AL3oKwVhHGqENHmqYbJTQQFb6mRgZYU&usqp=CAU')),
                      _buildImageContainerFromFile(File('https://www.kuoni.co.uk/alfredand/wp-content/uploads/2022/03/iStock-971437206-1024x576.jpg')),
                    ]
                        : _images.map((file) => _buildImageContainerFromFile(file)).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.orange.shade200 : Colors.orange.shade50,
                    ),
                  );
                }),
              ),
              SizedBox(height: screenHeight * 0.025),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      'Category',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 220),
                    child: Icon(
                      Icons.keyboard_double_arrow_right_rounded,
                      color: Colors.black12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.020),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Pick Images for Admin Page:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImages,
                      child: const Text('Pick Images from Gallery'),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
