class AudioModel {
  const AudioModel({
    required this.id,
    required this.url,
    required this.title,
    required this.artist,
    this.album = 'Quran',
    this.artUri,
  });

  final String id;
  final String url;
  final String title;
  final String artist;
  final String album;
  final String? artUri;
}
