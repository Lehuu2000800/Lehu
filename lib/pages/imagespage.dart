import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:unp_asset/details/detailImage.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageListPage extends StatefulWidget {
  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  List data = [];
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  AudioPlayer _audioPlayer = AudioPlayer();
  final searchController = TextEditingController();

  Future fetchData() async {
    // fetch data from API
    // replace the API_URL with your own API URL
    final response =
        await http.get(Uri.parse('http://192.168.202.40:3000/api/user/index'));
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
          ),
          Expanded(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  if (data[index]['file'].toString().endsWith('.jpg')) {
                    // display image
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => detailImage(
                                title: data[index]['name'],
                                body: data[index]['body'],
                                imageUrl:
                                    'http://192.168.202.40:3000/storage/uploads/photo/${data[index]['file']}',
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  'http://192.168.202.40:3000/storage/uploads/photo/${data[index]['file']}',
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            SizedBox(height: 10),
                            Text(data[index]['name'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text(data[index]['body']),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
