// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class DetailImage extends StatelessWidget {
//   final dynamic image;

//   const DetailImage({required this.image});

//   Future<void> _downloadFile(String url, BuildContext context) async {
//     try {
//       var request = await HttpClient().getUrl(Uri.parse(url));
//       var response = await request.close();
//       Uint8List bytes = await consolidateHttpClientResponseBytes(response);
//       final appDir = await getExternalStorageDirectory();
//       await File('${appDir?.path}/${image['name']}').writeAsBytes(bytes);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('File has been downloaded successfully.'),
//         ),
//       );
//     } catch (error) {
//       print(error);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(image['name']),
//         backgroundColor: Color.fromRGBO(212, 129, 102, 1),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Image.network(
//               'https://unpasset.testweb.skom.id/storage/uploads/photo/' +
//                   image['file'],
//               fit: BoxFit.contain,
//               loadingBuilder: (BuildContext context, Widget child,
//                   ImageChunkEvent? loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Center(
//                   child: CircularProgressIndicator(
//                     value: loadingProgress.expectedTotalBytes != null
//                         ? loadingProgress.cumulativeBytesLoaded /
//                             loadingProgress.expectedTotalBytes!
//                         : null,
//                   ),
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: 50.0),
//           ElevatedButton(
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all<Color>(
//                 Color.fromRGBO(212, 129, 102, 1),
//               ),
//             ),
//             onPressed: () async {
//               final status = await Permission.storage.request();
//               if (status.isGranted) {
//                 await _downloadFile(
//                   'https://unpasset.testweb.skom.id/storage/uploads/photo/' +
//                       image['file'],
//                   context,
//                 );
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Access denied.'),
//                   ),
//                 );
//               }
//             },
//             child: Text('Free Download'),
//           ),
//           SizedBox(height: 0.0),
//           Text(image['body' ],style: TextStyle(fontSize: 20),),
//           SizedBox(height: 250.0),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailImage extends StatefulWidget {
  final dynamic image;

  DetailImage({required this.image});

  @override
  _DetailImageState createState() => _DetailImageState();
}

class _DetailImageState extends State<DetailImage> {
  late String imageUrl;
  late String imageFileName;

  @override
  void initState() {
    super.initState();
    imageUrl = 'https://unpasset.testweb.skom.id/storage/uploads/photo/' +
        widget.image['file'];
    imageFileName = imageUrl.substring(imageUrl.lastIndexOf('/') + 1);
  }

  Future<Null> _saveImage() async {
    var status = await Permission.storage.status;

    if (status.isDenied || status.isRestricted) {
      await Permission.storage.request();
      status = await Permission.storage.status;
    }

    if (status.isGranted) {
      final file = await DefaultCacheManager().getSingleFile(imageUrl);
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(await file.readAsBytes()));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['isSuccess']
            ? 'Image saved successfully'
            : 'Failed to save image'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission denied to save image'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.image['data_user'];
    String userName = (widget.image['data_user'] != null)
        ? widget.image['data_user']['name']
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.image['name']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         
              ElevatedButton(
                onPressed: _saveImage,
                child: Text('Free Download') ,
              ),
            
          Expanded(
            child: Image.network(
              imageUrl,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.image['body']),
                SizedBox(height: 8.0),
                Text('Uploaded by: $userName'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
