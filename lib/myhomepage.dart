import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:unp_asset/pages/animation.dart';
import 'package:unp_asset/pages/audiopage.dart';
import 'package:unp_asset/pages/homepage.dart';
import 'package:unp_asset/pages/imagespage.dart';
import 'package:unp_asset/details/videopage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _pages = [
    homepage(),
    ImageGallery(),
    VideoListPage(),
    AudioPlayerScreen(),
    animations(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          child: Image.asset('asset/images/logoasset.png'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.account_circle,
              size: 35,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color.fromRGBO(212, 129, 102, 1),
        height: 60.0,
        index: _selectedIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.image, size: 30),
          Icon(Icons.video_camera_back, size: 30),
          Icon(Icons.audio_file_outlined, size: 30),
          Icon(Icons.animation, size: 30),
        ],
        onTap: _onItemTapped,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
      ),
    );
  }
}
