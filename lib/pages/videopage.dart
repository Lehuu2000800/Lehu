import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:unp_asset/details/detailImage.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  List data = [];
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  final searchController = TextEditingController();

  Future fetchData() async {
    // fetch data from API
    // replace the API_URL with your own API URL
    final response =
        await http.get(Uri.parse('https://unpasset.testweb.skom.id/api/user/index'));
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
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
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
          ),Expanded(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              if (data[index]['file'].toString().endsWith('.mp4')) {
                // display video
                _videoPlayerController = VideoPlayerController.network(
                  'https://unpasset.testweb.skom.id/storage/uploads/video/${data[index]['file']}',
                );
                _chewieController = ChewieController(
                  videoPlayerController: _videoPlayerController,
                  autoPlay: false,
                  looping: false,
                  errorBuilder: (context, errorMessage) {
                    return Center(
                      child: Text(errorMessage),
                    );
                  },
                );
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chewie(
                        controller: _chewieController,
                      ),
                      SizedBox(height: 10),
                      Text(data[index]['name'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(data[index]['body']),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        )
    ],
    ),
    );
  }
}
