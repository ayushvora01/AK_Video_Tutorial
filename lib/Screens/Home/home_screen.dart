// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:api_tutorial_api/Screens/Home/contact_us.dart';
import 'package:api_tutorial_api/Screens/Home/course_screen.dart';
import 'package:api_tutorial_api/Screens/Home/favourite_page.dart';
import 'package:api_tutorial_api/Screens/Home/video_courses_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const VideoCoursesPage(),
    const CourseScreen(),
    const FavoritesPage(),
    ContactUsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    } else {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Are you sure you want to exit?'),
              actions: <Widget>[
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.blue, // Set scaffold background to blue
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text(
              _selectedIndex == 0
                  ? 'Courses'
                  : _selectedIndex == 1
                      ? 'All videos'
                      : _selectedIndex == 2
                          ? 'Favourites'
                          : 'Contact us',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 1,
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.blue, // Selected item text color
          selectedLabelStyle: const TextStyle(fontSize: 15),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: 'All Videos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favourite',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_page_rounded),
              label: 'Contact Us',
            ),
          ],
        ),
      ),
    );
  }
}
