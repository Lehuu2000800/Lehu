import 'package:flutter/material.dart';
import 'package:unp_asset/details/VideoDetail.dart';
import 'package:video_player/video_player.dart';
import 'VideoDetail.dart';

class Video {
  final String title;
  final String url;

  Video({required this.title, required this.url});
}

class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  late List<Video> allVideos;
  late List<Video> filteredVideos;
  late List<Video> favorites;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    allVideos = [
      Video(
        title: 'Big Buck Bunny',
        url:
            'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
      ),
      Video(
        title: 'Sintel',
        url: 'https://sample-videos.com/video123/mp4/720/sintel_720p_1mb.mp4',
      ),
      Video(
        title: 'Tears of Steel',
        url:
            'https://sample-videos.com/video123/mp4/720/tears_of_steel_720p_1mb.mp4',
      ),
      Video(
        title: 'Elephant Dream',
        url:
            'https://sample-videos.com/video123/mp4/720/elephants_dream_720p_1mb.mp4',
      ),
    ];

    filteredVideos = allVideos;
    favorites = [];
    searchController = TextEditingController();
  }

  void _filterVideos(String query) {
    setState(() {
      filteredVideos = allVideos.where((video) {
        final title = video.title.toLowerCase();
        final lowerQuery = query.toLowerCase();

        return title.contains(lowerQuery);
      }).toList();
    });
  }

  void _toggleFavorite(Video video) {
    setState(() {
      if (favorites.contains(video)) {
        favorites.remove(video);
      } else {
        favorites.add(video);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player Demo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Videos',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterVideos,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredVideos.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              VideoDetailPage(video: filteredVideos[index]),
                        ),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: VideoPlayer(
                                  VideoPlayerController.network(
                                    filteredVideos[index].url,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8.0,
                                right: 8.0,
                                child: IconButton(
                                  icon:
                                      favorites.contains(filteredVideos[index])
                                          ? Icon(Icons.favorite)
                                          : Icon(Icons.favorite_border),
                                  color: Colors.red,
                                  onPressed: () =>
                                      _toggleFavorite(filteredVideos[index]),
                                ),
                              ),
                              Positioned(
                                bottom: 8.0,
                                left: 8.0,
                                child: Text(
                                  filteredVideos[index].title,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}