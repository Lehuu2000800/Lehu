import 'package:flutter/material.dart';
import 'package:unp_asset/Widgets/auth/auth_signIn.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthsingIn(),
    );
  }
}
