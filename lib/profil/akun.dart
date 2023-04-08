import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unp_asset/Widgets/auth/auth_signIn.dart';
import 'package:unp_asset/Widgets/auth/update_profile.dart';
import 'package:unp_asset/details/uploadFile.dart';
import 'package:unp_asset/profil/signIn.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

String? finalToken;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SecureStorage secureStorage = SecureStorage();

  void initState() {
    secureStorage.readSecureData('token').then((value) {
      finalToken = value;
      setState(() {});
    });
    print(finalToken);
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    debugPrint(finalToken);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(212, 129, 102, 1),
        title: Text('Profile'),
        actions: [
          finalToken != null
              ? IconButton(
                  icon: Icon(Icons.upload),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadForm()),
                    );
                  },
                )
              : Container(),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              secureStorage.deleteSecureData('token');
              setState(() {});
              Navigator.of(context).pushReplacementNamed('/');
            },
          )
          //
        ],
      ),
      body: finalToken == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'asset/images/logoasset.png',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Upss kamu belum memiliki akun. Mulai buat akun agar bisa menggunakan fitur di UNP ASSET lebih mudah',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(212, 129, 102, 1),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 250),
                ],
              ),
            )
          : 
          update(),
    );
  }
}

