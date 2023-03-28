import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('asset/images/logo.png'),
              height: 120.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'Lets Sign You Up',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Welcome Back To UNP ASSET',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 32.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {},
              child: Text("Sign In"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(212, 129, 102, 1),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {},
            //   child: Text("Sign Up"),
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all<Color>(
            //       Color.fromRGBO(212, 129, 102, 1),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
