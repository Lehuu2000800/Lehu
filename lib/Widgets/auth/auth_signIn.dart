import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:unp_asset/profil/akun.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
var _isLogin =true;
var _userName ='';
var _userEmail ='';
var _userPassword ='';
final _emailcontroller = TextEditingController();
final _passwordcontroller = TextEditingController();
final SecureStorage secureStorage = SecureStorage();


 doLogin(String email, String password) async {
    final url = Uri.parse('http://unpasset.testweb.skom.id/api/login');

  try {
    final response = await http.post(url, headers: {'Accept' : 'application/json', 'Content-Type' : 'application/json; charset=UTF-8 '}, body: jsonEncode({
      'email' : email,
      'password' : password,
    }));

    if (response.statusCode == 200) {
      print('sukses');
      secureStorage.writeSecureData('token', email);
      print(email);
      Navigator.of(context).pushReplacementNamed('/');
      
    } else {
      print(response.statusCode);
    
    }
  } catch (e) {
    throw(e);
  } 
 }

void _trySubmit(){
  if (!widget.isLogin){
    doLogin(_emailcontroller.text, _passwordcontroller.text);
  }else{
    final url = Uri.parse('http://unpasset.testweb.skom.id/api/signup');
    http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({
      'name': _userName,
      'email': _emailcontroller.text,
      'password': _passwordcontroller.text,
    })).then((response) {
      print(response.body);
      Navigator.of(context).pushReplacementNamed('/profile');
    }).catchError((error) => print(error));
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
              !widget.isLogin ?'Lets Sign You In':'Lets Sign You Up',
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
            if (widget.isLogin)
            TextFormField(
              key: ValueKey('Username'),
              validator: (value){
                if (value!.isEmpty || value.length < 4){
                  return 'Please enter at least 4 characters';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'UserName',
              ),
              onSaved: (value){
              _userEmail = value!;
            },
            ),
            TextFormField(
              key: ValueKey('email'),
              controller: _emailcontroller,
              validator: (value){
                if (value!.isEmpty || !value.contains('@')){
                  return 'Please enter a valid email address';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Email address'),
              onSaved: (value){
              _userName = value!;
            },
            ),
            TextFormField(
              key: ValueKey('password'),
              controller: _passwordcontroller,
              validator: (value){
                if (value!.isEmpty || value.length < 8){
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onSaved: (value){
              _userPassword = value!;
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
              child: Text(!widget.isLogin ? 'Create new account':'I already have an account'),
              onPressed: () {
                setState(() {
                   widget.isLogin = !widget.isLogin;
                });
              // launchUrl(Uri.parse('http://192.168.137.1:3000/signup'));
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
