import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../details/detailImage.dart';

class ImageListPage extends StatefulWidget {
  String _searchText = '';
  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  List<dynamic> images = [];

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    final response = await http.get(
      Uri.parse('https://unpasset.testweb.skom.id/api/user/index'),
    );

    if (response.statusCode == 200) {
      setState(() {
        images = jsonDecode(response.body)['data']
            .where((item) =>
                item['category_id'] == '3' && item['file'].contains('.jpg'))
            .toList();
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  List<dynamic> get filteredImages {
    if (_searchText.isEmpty) {
      return images;
    }

    final lowerSearchText = _searchText.toLowerCase();

    return images
        .where(
          (item) =>
              item['name'].toLowerCase().contains(lowerSearchText) ||
              item['body'].toLowerCase().contains(lowerSearchText),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              _searchText = value;
            });
          },
        ),
      ),
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: filteredImages.length,
        itemBuilder: (context, index) {
          final image = filteredImages[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailImage(
                    image: image,
                  ),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      'https://unpasset.testweb.skom.id/storage/uploads/photo/' +
                          image['file'],
                      fit: BoxFit.fitWidth,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(image['name']),
                  SizedBox(height: 4.0),
                  Text(image['body']),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
