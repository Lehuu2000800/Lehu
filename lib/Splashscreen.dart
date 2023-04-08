import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unp_asset/myhomepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      // Navigasi ke halaman berikutnya setelah 3 detik
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/images/logoasset.png'),
            fit: BoxFit.contain,
          ),
        ),

      ),
    );
  }
}
