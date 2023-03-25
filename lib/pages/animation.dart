import 'package:flutter/material.dart';

class animations extends StatefulWidget {
  const animations({super.key});

  @override
  State<animations> createState() => _animationsState();
}

class _animationsState extends State<animations> {

  List<Container> daftarAnimasi = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Animations"),
      ),
      body: new GridView.count(
        crossAxisCount: 2,
        children: daftarAnimasi,
      ),
    );
  }
}
