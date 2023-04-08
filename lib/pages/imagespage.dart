import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class ImageListPage extends StatefulWidget {
   String _searchText = '';
  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  
  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    final response = await http
        .get(Uri.parse('https://unpasset.testweb.skom.id/api/user/index'));

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailImage(image: image),
                ),
              );
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network(
                      'http://unpasset.testweb.skom.id/storage/uploads/photo/' +
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
 
class DetailImage extends StatelessWidget {
  
  final dynamic image;

  const DetailImage({required this.image});

  Future<void> _downloadFile(String url) async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await File(image['name']).writeAsBytes(bytes);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(image['name']),
        backgroundColor: Color.fromRGBO(212, 129, 102, 1),
      ),
      body: Column(
        children: [
           
          Expanded(
            child: Image.network(
              'http://unpasset.testweb.skom.id/storage/uploads/photo/' +
                  image['file'],
              fit: BoxFit.contain,
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
          SizedBox(height: 50.0),
          ElevatedButton(
             style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(212, 129, 102, 1),
                          ),
                        ),
            onPressed: () {
              _downloadFile(
                'http://unpasset.testweb.skom.id/storage/uploads/photo/' +
                    image['file'],
              );
            },
            child: Text('Free Download'),
          ),
          SizedBox(height: 0.0),
          Text(image['body']),
          SizedBox(height: 250.0),
        ],
      ),
    );
  }
}

