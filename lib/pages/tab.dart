import 'package:flutter/material.dart';

import '../details/myMedia.dart';
import '../details/uploadFile.dart';

class tabPage extends StatelessWidget {
  const tabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(212, 129, 102, 1),
          title: Text('Tab'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Media'),
              Tab(text: 'Upload'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Implementasi untuk menampilkan video
            MyMedia(),
            UploadDataScreen()
          ],
        ),
      ),
    );
  }
}
