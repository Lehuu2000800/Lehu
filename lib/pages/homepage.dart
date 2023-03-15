import 'package:flutter/material.dart';


class homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('asset/images/background.jpg'),fit: BoxFit.cover)),
      child: Center(
        child: Text(
          'Home',
          style: TextStyle(fontSize: 30.0),
        ),
      ),
    );
  }
}