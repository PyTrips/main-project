import 'dart:async';
import 'package:final_yearproject/screens/home%20page/Navigation_pages/favorite_page.dart';
import 'package:final_yearproject/screens/home%20page/Navigation_pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login & sign page/login_page.dart';
import '../weather/weather-home.dart';

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
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  int _currentIndex = 0; // Current tab index

  @override
  void initState() {
    super.initState();
    _startTimer();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Successfully signed out!'),
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => login_page()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  final Map<String, bool> _favorites = {};

  void _toggleFavorite(String item) {
    setState(() {
      if (_favorites.containsKey(item)) {
        _favorites[item] = !_favorites[item]!;
      } else {
        _favorites[item] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            // Home Screen
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60, left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 1),
                          child: Row(
                            children: [
                              Text(
                                'Hi Makkale',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 140),
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Image.asset(
                                    'assets/path-removebg-preview.png'),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.14),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>WeatherHome()));
                              },
                              child: Container(
                                child: Image.asset('assets/cloudy.png'),

                                width: 25,
                                height: 25,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.025),
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
                                'Explore to ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'PUDUCHERRY',
                                style: TextStyle(
                                  fontSize: 18,
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
                        children: [
                          _buildImageContainer(
                              'https://www.agoda.com/wp-content/uploads/2024/04/Featured-image-Pondicherry-India.jpg'),
                          _buildImageContainer(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVFeKW8s_C8HEh9PAwuZQSDE0-F8ZH2SD36VK-AL3oKwVhHGqENHmqYbJTQQFb6mRgZYU&usqp=CAU'),
                          _buildImageContainer(
                              'https://www.kuoni.co.uk/alfredand/wp-content/uploads/2022/03/iStock-971437206-1024x576.jpg'),
                        ],
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
                          color: _currentPage == index
                              ? Colors.orange.shade200
                              : Colors.orange.shade50,
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    height: screenHeight * 0.025,
                  ),
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
                  SizedBox(
                    height: screenHeight * 0.020,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Category Items (Temple, Beach, etc.)
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Temple tapped!");
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.070,
                                    child: Image.network(
                                      'https://www.trawell.in/admin/images/upload/092856353Pondicherry_Varadaraja_Perumal_Temple_Main.jpg',
                                      fit: BoxFit.fill,
                                    ),
                                    decoration: BoxDecoration(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Temple'),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Beach tapped!");
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.070,
                                    child: Image.network(
                                      'https://static-blog.treebo.com/wp-content/uploads/2021/01/Karaikal-Beach-1024x578.jpg',
                                      fit: BoxFit.fill,
                                    ),
                                    decoration: BoxDecoration(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Beach'),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("shopping tapped!");
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.070,
                                    child: Image.network(
                                      'https://ourpondy.com/wp-content/uploads/2020/02/Casablanca.jpg',
                                      fit: BoxFit.fill,
                                    ),
                                    decoration: BoxDecoration(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Shopping'),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Hotel tapped!");
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.070,
                                    child: Image.network(
                                      'https://cf.bstatic.com/xdata/images/hotel/max1024x768/118147636.jpg?k=1bca2b5c2fb5b1481ab9dd486838d59082d1775df98e1855cfd0f9b75881e63c&o=&hp=1',
                                      fit: BoxFit.fill,
                                    ),
                                    decoration: BoxDecoration(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Hotel'),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Restarant tapped!");
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.070,
                                    child: Image.network(
                                      'https://media-assets.swiggy.com/swiggy/image/upload/fl_lossy,f_auto,q_auto/b2ab0b7ccd417709f2a8361477e5d4fd',
                                      fit: BoxFit.fill,
                                    ),
                                    decoration: BoxDecoration(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Restaurants'),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Theater tapped!");
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.070,
                                    child: Image.network(
                                      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/12/7f/83/5f/inside-the-screen.jpg?w=500&h=500&s=1',
                                      fit: BoxFit.fill,
                                    ),
                                    decoration: BoxDecoration(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Theater'),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("Pub tapped!");
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    width: screenWidth * 0.15,
                                    height: screenHeight * 0.070,
                                    child: Image.network(
                                      'https://www.fabhotels.com/blog/wp-content/uploads/2019/02/pub1.jpg',
                                      fit: BoxFit.fill,
                                    ),
                                    decoration: BoxDecoration(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Pub'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.025,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Text(
                      'Recommended',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.025,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Stack(
                            children: [
                              Container(
                                height: 300,
                                width: 190,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    'https://static.toiimg.com/img/99391984/Master.jpg',
                                    fit: BoxFit.cover,
                                    height: 300,
                                    width: 190,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  icon: Icon(
                                    _favorites['Auroville'] == true
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color: _favorites['Auroville'] == true
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _toggleFavorite('Auroville');
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height: 60,
                                  width: 190,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 3,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Auroville',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 18,
                                          ),
                                          Text(
                                            '4.5',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Favorite_page(),
            const Profile_page()

            // Profile Screen
            // const Center(child: Text('Profile Screen')),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.orangeAccent,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black12,
          width: 5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return Image.asset(
              'assets/dummy-post-horisontal.jpg',
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
