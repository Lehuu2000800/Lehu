import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:unp_asset/pages/animation.dart';
import 'package:unp_asset/pages/audiopage.dart';
import 'package:unp_asset/pages/homepage.dart';
import 'package:unp_asset/pages/imagespage.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  List<Widget> _pages = [    HomePage(),    Page1(),    Page2(),    Page3(),  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Curved Navigation Bar Demo'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            // bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.blue,
        height: 60.0,
        index: _selectedIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.chat, size: 30),
          Icon(Icons.person, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        onTap: _onItemTapped,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
      ),
    );
  }
}