import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:mynotes/Screens/Addvehicles/add_vehicles.dart';
import 'package:mynotes/Screens/Home/main_home_screen.dart';
import 'package:mynotes/Screens/Settings/settings.dart';
import 'package:mynotes/Screens/profile/profile_page.dart';

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _currentIndex = 0;
  final List<Widget> _screens =[
    HomeScreen(),
    AddVehicles(),
    SettingsPage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      backgroundColor: Colors.grey.shade900,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey.shade900,
        color: Color(0xFFD20606),
        animationDuration: Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          print(index);
        },
      ),
    );
  }
}