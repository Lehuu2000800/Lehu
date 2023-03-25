import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;

class ImageGallery extends StatefulWidget {
  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  List<String> imageUrls = [
    "https://picsum.photos/id/237/200/300",
    "https://picsum.photos/id/238/200/300",
    "https://picsum.photos/id/239/200/300",
    "https://picsum.photos/id/240/200/300",
    "https://picsum.photos/id/241/200/300",
    "https://picsum.photos/id/242/200/300",
  ];

  List<String> favoriteImages = [];
  String query = '';

  Future<void> downloadImage(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.bodyBytes),
          quality: 60,
          name: 'img_${DateTime.now().millisecondsSinceEpoch}');
      print('Image saved: $result');
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  void toggleFavorite(String url) {
    setState(() {
      if (favoriteImages.contains(url)) {
        favoriteImages.remove(url);
      } else {
        favoriteImages.add(url);
      }
    });
  }

  List<String> get filteredUrls {
    if (query.isEmpty) {
      return imageUrls;
    }
    return imageUrls
        .where((url) => url.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                  context: context, delegate: ImageSearchDelegate(imageUrls));
              setState(() {
                query = result!;
              });
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: filteredUrls.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          final url = filteredUrls[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailImage(
                    imageUrl: url,
                    onDownload: () {
                      downloadImage(url);
                    },
                    onToggleFavorite: () {
                      toggleFavorite(url);
                    },
                    isFavorite: favoriteImages.contains(url),
                  ),
                ),
              );
            },
            child: Image.network(url),
          );
        },
      ),
    );
  }
}

class ImageSearchDelegate extends SearchDelegate<String> {
  final List<String> imageUrls;

  ImageSearchDelegate(this.imageUrls);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
         
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredUrls = imageUrls
        .where((url) => url.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: filteredUrls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        final url = filteredUrls[index];
        return GestureDetector(
          onTap: () {
            close(context, url);
          },
          child: Image.network(url),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredUrls = query.isEmpty
        ? []
        : imageUrls
            .where((url) => url.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: filteredUrls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        final url = filteredUrls[index];
        return GestureDetector(
          onTap: () {
            query = url;
            showResults(context);
          },
          child: Image.network(url),
        );
      },
    );
  }
}

class DetailImage extends StatelessWidget {
  final String imageUrl;
  final Function() onDownload;
  final Function() onToggleFavorite;
  final bool isFavorite;

  const DetailImage({
    required this.imageUrl,
    required this.onDownload,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            color: isFavorite ? Colors.red : null,
            onPressed: () {
              onToggleFavorite();
            },
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              onDownload();
            },
          ),
        ],
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
