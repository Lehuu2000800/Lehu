import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:unp_asset/profil/akun.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:url_launcher/url_launcher.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future writeSecureData(String key, String value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }

  Future readSecureData(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }

  Future deleteSecureData(String key) async {
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }
}

class AuthsingIn extends StatefulWidget {
  AuthsingIn({super.key});

  bool isLogin = false;

  @override
  State<AuthsingIn> createState() => _AuthsingIn();
}

class _AuthsingIn extends State<AuthsingIn> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userName = '';
  var _userEmail = '';
  var _userPassword = '';
  final _emailcontroller = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final SecureStorage secureStorage = SecureStorage();

  doLogin(String email, String password) async {
    final url = Uri.parse('http://192.168.202.40:3000/api/login');

    final response = await http.post(url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8 '
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }));

    if (response.statusCode == 200) {
      print('sukses');
      secureStorage.writeSecureData('token', email);
      secureStorage.writeSecureData('token2', json.encode(response.body));

      print('token: ${json.encode(response.body)}');

      String? token;
      String? filterToken;
      await SecureStorage().readSecureData('token2').then((value) {
        token = value;
        filterToken = token!.replaceAll('"', '');
      });
      final url =
          Uri.parse('http://192.168.202.40:3000/api/user/data-user');
      final responseLogin = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer $filterToken",
        },
      );
      secureStorage.writeSecureData(
          'name', json.decode(responseLogin.body)['name']);
      secureStorage.writeSecureData(
          'id', json.decode(responseLogin.body)['id'].toString());

      print('email $email');
      print('name : ${json.decode(responseLogin.body)['name']}');

      Navigator.of(context).pushReplacementNamed('/');
    } else {
      print(response.body);
      Alert(context: context, title: "Warning", desc:"Login Tidak Berhasil")
      .show();
    }
  }

  doSignup(String name, String email, String password) async {
    final url = Uri.parse('http://192.168.202.40:3000/api/signup');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
      },
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    print('sukses');
    Alert(context: context, title: "Warning", desc:"Sign Up Berhasil",
    buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  void _trySubmit() {
    if (!widget.isLogin) {
      doLogin(_emailcontroller.text, _passwordcontroller.text);
    } else {
      doSignup(_userNameController.text, _emailcontroller.text,
          _passwordcontroller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          key: _formKey,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('asset/images/logo.png'),
              height: 120.0,
            ),
            SizedBox(height: 16.0),
            Text(
              !widget.isLogin ? 'Lets Sign You In' : 'Getting Started',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              !widget.isLogin
                  ? 'Welcome Back To UNP ASSET'
                  : 'Create an account to continue',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
            if (widget.isLogin)
              TextFormField(
                key: ValueKey('UserName'),
                validator: (value) {
                  if (value!.isEmpty || value.length < 4) {
                    return 'Please enter at least 4 characters';
                  }
                  return null;
                },
                controller: _userNameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'UserName',
                ),
                onSaved: (value) {
                  _userName = value!;
                },
              ),
            TextFormField(
              key: ValueKey('email'),
              controller: _emailcontroller,
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Email address'),
              onSaved: (value) {
                _userEmail = value!;
              },
            ),
            TextFormField(
              key: ValueKey('password'),
              controller: _passwordcontroller,
              validator: (value) {
                if (value!.isEmpty || value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onSaved: (value) {
                _userPassword = value!.toString();
              },
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _trySubmit,
              child: Text(!widget.isLogin ? 'Sign In' : 'Sign Up'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(212, 129, 102, 1),
                ),
              ),
            ),
            OutlinedButton(
              child: Text(!widget.isLogin
                  ? 'Create new account'
                  : 'I already have an account'),
              onPressed: () {
                setState(() {
                  widget.isLogin = !widget.isLogin;
                });
                // launchUrl(Uri.parse('http://unpasset.testweb.skom.id/signup'));
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  Color.fromRGBO(212, 129, 102, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
