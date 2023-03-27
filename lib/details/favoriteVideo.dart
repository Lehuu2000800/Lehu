import 'package:flutter/material.dart';
import 'videopage.dart';

class FavoriteVideos {
  List<Video> videos = [];

  void addVideo(Video video) {
    if (!videos.contains(video)) {
      videos.add(video);
    }
  }

  void removeVideo(Video video) {
    videos.remove(video);
  }

  bool containsVideo(Video video) {
    return videos.contains(video);
  }
}
