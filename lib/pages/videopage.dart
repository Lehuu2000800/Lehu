import 'package:flutter/material.dart';

class videopage extends StatefulWidget {
  @override
  _VideoSearchPageState createState() => _VideoSearchPageState();
}

class _VideoSearchPageState extends State<videopage> {
  String _searchTerm = '';
  List<String> _videoList = [
    'Video 1',
    'Video 2',
    'Video 3',
    'Video 4',
    'Video 5',
    'Video 6',
    'Video 7',
    'Video 8',
    'Video 9',
    'Video 10'
  ];

  List<String> _searchResults = [];

  void _handleSearch() {
    setState(() {
      _searchResults = _videoList
          .where((video) =>
              video.toLowerCase().contains(_searchTerm.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter search term',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _handleSearch,
                ),
              ),
              onChanged: (value) {
                _searchTerm = value;
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
