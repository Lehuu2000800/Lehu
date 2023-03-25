class Video {
  final String title;
  final String url;

  Video({required this.title, required this.url});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'] as String,
      url: json['url'] as String,
    );
  }
}
