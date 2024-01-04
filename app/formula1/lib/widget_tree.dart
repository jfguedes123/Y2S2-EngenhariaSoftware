import 'package:firebase_auth/firebase_auth.dart';
import 'package:formula1/auth.dart';
import 'package:formula1/pages/calendar.dart';
import 'package:formula1/pages/login.dart';
import 'package:formula1/pages/circuits.dart';
import 'package:formula1/pages/driver_standings.dart';
import 'package:flutter/material.dart';
import 'package:formula1/pages/news.dart';
import 'package:formula1/pages/home_page.dart';
import 'package:formula1/pages/standings.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  WidgetTreeState createState() => WidgetTreeState();
}

class WidgetTreeState extends State<WidgetTree> {
  final Auth _auth = Auth();
  bool isFirstTimeLaunch = true;
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePagePage(),
    CircuitsPage(),
    DriverStandingsPage(),
    CalendarPage(),
    NewsPage(),
    ConstructorsStandingsPage(),
  ];



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Formula 1',
                style: TextStyle(
                  fontFamily: 'F1',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ],
            ),
            body: _widgetOptions.elementAt(_selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.white),
                  activeIcon: Icon(Icons.home, color: Colors.black),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map, color: Colors.white),
                  activeIcon: Icon(Icons.map, color: Colors.black),
                  label: 'Circuits',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: Colors.white),
                  activeIcon: Icon(Icons.person, color: Colors.black),
                  label: 'Drivers',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  activeIcon: Icon(Icons.calendar_today, color: Colors.black),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article, color: Colors.white),
                  activeIcon: Icon(Icons.article, color: Colors.black),
                  label: 'News',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.emoji_events, color: Colors.white),
                  activeIcon: Icon(Icons.emoji_events, color: Colors.black),
                  label: 'Standings',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.white,
              backgroundColor: Colors.red,
              onTap: _onItemTapped,
            ),

          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}


