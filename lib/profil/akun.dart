import 'package:flutter/material.dart';
import 'package:unp_asset/details/uploadFile.dart';
import 'package:unp_asset/profil/signIn.dart';
// import 'package:unp_asset/profil/signUp.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(212, 129, 102, 1),
        title: Text('Login Page'),
      ),
      body: Center(
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
                  child: Text('Login',
                  style: TextStyle(
                    fontSize: 20,
                  ),),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 250),
          ],
        ),
      ),
    );
  }
}
