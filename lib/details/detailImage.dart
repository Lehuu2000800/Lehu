import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class detailImage extends StatefulWidget {
  final String title;
  final String body;
  final String imageUrl;

  detailImage({
    required this.title,
    required this.body,
    required this.imageUrl,
  });

  @override
  _detailImageState createState() => _detailImageState();
}

class _detailImageState extends State<detailImage> {
  bool downloading = false;
  late String localPath;

  Future<void> downloadFile() async {
    setState(() {
      downloading = true;
    });

    final response = await http.get(Uri.parse(widget.imageUrl));

    final directory = await getExternalStorageDirectory();
    final fileName = widget.title + '.jpg';
    final filePath = '${directory!.path}/$fileName';

    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    final result = await ImageGallerySaver.saveFile(filePath);

    setState(() {
      downloading = false;
      localPath = filePath;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: result['isSuccess']
          ? Text('File downloaded successfully and saved to gallery.')
          : Text('Error while downloading file.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromRGBO(212, 129, 102, 1),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.body,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: downloading ? null : downloadFile,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                      backgroundColor: Color.fromRGBO(212, 129, 102, 1),
                    ),
                    child: downloading
                        ? CircularProgressIndicator()
                        : Text('Free Download'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
