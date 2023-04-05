import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'auth_signIn.dart';

String? finalToken;
String? finalNama;

class update extends StatefulWidget {
  const update({
    super.key,
  });

  @override
  State<update> createState() => _updateState();
}

class _updateState extends State<update> {
  final SecureStorage secureStorage = SecureStorage();

  void initState() {
      secureStorage.readSecureData('token').then((value) {
        finalToken = value;
        print(finalToken);
        print('sukses'); // move print statement here
        setState(() {});
      });
      secureStorage.readSecureData('name').then((value) {
        finalNama = value;
        print(finalNama);
        print('sukses'); // move print statement here
        setState(() {});
      });
      super.initState();
    }
    
  Future<void> updateData(
    
      String name, String password, String password_confirmation) async {
       String? finalId;
       String? token;
        String? filterToken;
      try{await SecureStorage().readSecureData('token2').then((value) {
        token = value;
        filterToken = token!.replaceAll('"', '');
      });
        await SecureStorage().readSecureData('id').then((value) {
        finalId = value;
      });
    var url =
        Uri.parse('https://unpasset.testweb.skom.id/api/user/update-user/$finalId');
    var response = await http.patch(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $filterToken', // add authorization token header
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'password': password,
        'password_confirmation': password_confirmation,
      }),
    );
    print(password);
    print(password_confirmation);
    if (response.statusCode == 200) {
      print('Data updated successfully');
      Navigator.of(context).pop();
      
    } else {
      throw Exception('Failed to update data');
    }
    }catch(error){
      print(error);
    }
    }
    

  @override
  Widget build(BuildContext context) {
    TextEditingController _passwordcontroller = TextEditingController();
    TextEditingController _password_configurasicontroller = TextEditingController();
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
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    // labelText: 'Name',
                    hintText: finalNama,
                  ),
                ),
                TextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    // labelText: 'Email',
                    hintText: finalToken,
                  ),
                ),
                TextFormField(
                  controller: _passwordcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    
                    // labelText: 'Password',
                  ),
                ),
                TextFormField(
                  controller: _password_configurasicontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    // labelText: 'Retype Password',
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
                    updateData('name', _passwordcontroller.text, _password_configurasicontroller.text)
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
