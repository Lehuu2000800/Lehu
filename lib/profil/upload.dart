import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Widgets/auth/auth_signIn.dart';

String? finalToken;
class update extends StatefulWidget {
  const update({
    super.key,
  });

  @override
  State<update> createState() => _updateState();
}

class _updateState extends State<update> {
    final SecureStorage secureStorage = SecureStorage();
  Future<void> updateData(
      String name, String password, String password_confirmation) async {
    var id;
    var url =
        Uri.parse('http://unpasset.testweb.skom.id/api/user/update-user/$id');
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $finalToken', // add authorization token header
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'password': password,
        'password_confirmation': password_confirmation,
      }),
    );
    if (response.statusCode == 200) {
      print('Data updated successfully');
    } else {
      throw Exception('Failed to update data');
    }

    void initState() {
      secureStorage.readSecureData('token').then((value) {
        finalToken = value;
        print(finalToken);
        print('sukses'); // move print statement here
        setState(() {});
      });
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage('asset/images/logo.png'),
                    height: 120.0,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Welcome To UNP ASSET',
                    style: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Retype Password',
                    ),
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    child: Text('Update'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(212, 129, 102, 1),
                      ),
                    ),
                    onPressed: () {
                      updateData(
                              'name', 'password', 'password_confirmation')
                          .then((_) {
                        // show success message or navigate to a success page
                      }).catchError((error) {
                        // handle the error
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
