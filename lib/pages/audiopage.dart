import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AudioListPage extends StatefulWidget {
  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  List data = [];
  AudioPlayer _audioPlayer = AudioPlayer();
  final searchController = TextEditingController();

  Future fetchData() async {
    // fetch data from API
    // replace the API_URL with your own API URL
    final response = await http
        .get(Uri.parse('https://unpasset.testweb.skom.id/api/user/index'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void searchData(String query) {
    // search data based on query
    setState(() {
      data = data
          .where((item) =>
              item['name'].toLowerCase().contains(query.toLowerCase()) ||
              item['body'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (query) {
                          searchData(query);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search_sharp),
                      onPressed: () {
                        searchData(searchController.text);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                if (data[index]['file'].toString().endsWith('.mp3')) {
                  // display audio
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: Icon(Icons.music_note),
                      title: Text(data[index]['name']),
                      subtitle: Text(data[index]['body']),
                      trailing: IconButton(
                        icon: Icon(_audioPlayer.state == PlayerState.playing
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: () {
                          if (_audioPlayer.state == PlayerState.playing) {
                            _audioPlayer.pause();
                          } else if (_audioPlayer.state == PlayerState.paused ||
                              _audioPlayer.state == PlayerState.stopped) {
                            _audioPlayer.play(UrlSource(
                                'https://unpasset.testweb.skom.id/storage/uploads/audio/${data[index]['file']}'));
                          }
                        },
                      ),
                      onTap: () {
                        if (_audioPlayer.state == PlayerState.playing) {
                          _audioPlayer.pause();
                        } else if (_audioPlayer.state == PlayerState.paused ||
                            _audioPlayer.state == PlayerState.stopped) {
                          _audioPlayer.play(UrlSource(
                              'https://unpasset.testweb.skom.id/storage/uploads/audio/${data[index]['file']}'));
                        }
                      },
                    ),
                  );
                } else {
                  return Container(); // return empty container for other file types
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
