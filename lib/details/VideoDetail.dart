
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unp_asset/details/videopage.dart';
import 'package:video_player/video_player.dart';

class VideoDetailPage extends StatelessWidget {
  final Video video;

  VideoDetailPage({required this.video});
  
  get path => null;

 Future<void> _downloadFile() async {
    final downloadUrl = video.url;
    final fileName = video.title.replaceAll(' ', '_') + '.mp4';
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getApplicationDocumentsDirectory();
      final filePath = path.join(baseStorage!.path, fileName);
      final dio = Dio();
      await dio.download(downloadUrl, filePath,
          onReceiveProgress: (count, total) {
        print('Downloaded $count/$total');
      });
    } else {
      throw Exception('Permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(video.title),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: VideoPlayer(
              VideoPlayerController.network(video.url),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Text('Download'),
                  onPressed: _downloadFile,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.favorite),
                  color: Colors.red,
                  onPressed: () {
                    // Add code to add video to favorites
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  join(String path, String fileName) {}
}
