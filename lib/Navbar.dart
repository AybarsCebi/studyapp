import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:studyapp/HomePage.dart';
import 'package:studyapp/LeaderboardPage.dart';
import 'package:studyapp/ProfilePage.dart';
import 'package:studyapp/constraints.dart';
import 'package:studyapp/toDoPage.dart';
class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedPage = 0;

   final List<Widget> _pages = [
    HomePage(),
    toDoPage(),
    LeaderboardPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: IndexedStack(
        index: _selectedPage,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedPage,
        backgroundColor: backgroundColor,
        buttonBackgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 300),
        height: screenHeight/12,
        items: [
          Icon(Icons.home, size: 35,),
          Icon(Icons.add_task, size: 35,),
          Icon(Icons.leaderboard, size: 35,),
          Icon(Icons.account_circle, size: 35)
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}