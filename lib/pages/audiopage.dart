import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class AudioListPage extends StatefulWidget {
  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  List<dynamic> audios = [];

  @override
  void initState() {
    super.initState();
    fetchAudios();
  }

  Future<void> fetchAudios() async {
    final response = await http
        .get(Uri.parse('https://unpasset.testweb.skom.id/api/user/index'));

    if (response.statusCode == 200) {
      setState(() {
        audios = jsonDecode(response.body)['data']
            .where((item) =>
                item['category_id'] == '5' && item['file'].contains('.mp3'))
            .toList();
      });
    } else {
      throw Exception('Failed to load audios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Audio List'),
      // ),
      body: ListView.builder(
        itemCount: audios.length,
        itemBuilder: (context, index) {
          final audio = audios[index];
          return ListTile(
            title: Text(audio['name']),
            subtitle: Text(audio['body']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioPlayerScreen(audio: audio),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AudioPlayerScreen extends StatefulWidget {
  final dynamic audio;

  AudioPlayerScreen({required this.audio});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    await _player.play(('http://unpasset.testweb.skom.id/storage/uploads/audio/' +
            widget.audio['file']) as Source);
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _pauseAudio() async {
    await _player.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.audio['name']),
        backgroundColor: Color.fromRGBO(212, 129, 102, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                if (_isPlaying) {
                  _pauseAudio();
                } else {
                  _playAudio();
                }
              },
            ),
            SizedBox(height: 16.0),
            Text(widget.audio['body']),
          ],
        ),
      ),
    );
  }
}