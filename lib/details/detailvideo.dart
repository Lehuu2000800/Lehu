import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class detailvideo extends StatefulWidget {
  final String file;
  final String name;
  final String body;

  detailvideo({
    required this.file,
    required this.name,
    required this.body,
  });

  @override
  _detailvideoState createState() => _detailvideoState();
}

class _detailvideoState extends State<detailvideo> {
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(
      'http://192.168.202.40:3000/storage/uploads/video/${widget.file}',
    );
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(errorMessage),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Chewie(
            controller: _chewieController,
          ),
          SizedBox(height: 10),
          Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(widget.body),
        ],
      ),
    );
  }
}
