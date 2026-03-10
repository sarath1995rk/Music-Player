import 'dart:convert';

class SongModel {
  final String id;
  final String artist;
  final String songName;
  final String hexCode;
  final String songUrl;
  final String thumbnailUrl;
  final bool isMine;
  final bool? isPlaying;

  SongModel({
    required this.id,
    required this.artist,
    required this.songName,
    required this.hexCode,
    required this.songUrl,
    required this.thumbnailUrl,
    required this.isMine,
    this.isPlaying = false,
  });

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] as String,
      artist: map['artist'] as String,
      songName: map['songName'] as String,
      hexCode: map['hexCode'] as String,
      songUrl: map['songUrl'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
      isMine: map['isMine'] as bool,
    );
  }

  SongModel copyWith({
    String? id,
    String? artist,
    String? songName,
    String? hexCode,
    String? songUrl,
    String? thumbnailUrl,
    bool? isMine,
    bool? isPlaying,
  }) {
    return SongModel(
      id: id ?? this.id,
      artist: artist ?? this.artist,
      songName: songName ?? this.songName,
      hexCode: hexCode ?? this.hexCode,
      songUrl: songUrl ?? this.songUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isMine: isMine ?? this.isMine,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'artist': artist,
      'songName': songName,
      'hexCode': hexCode,
      'songUrl': songUrl,
      'thumbnailUrl': thumbnailUrl,
      'isMine': isMine,
      'isPlaying': isPlaying,
    };
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, artist: $artist, songName: $songName, hexCode: $hexCode, songUrl: $songUrl, thumbnailUrl: $thumbnailUrl) isMine: $isMine';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.artist == artist &&
        other.songName == songName &&
        other.hexCode == hexCode &&
        other.songUrl == songUrl &&
        other.thumbnailUrl == thumbnailUrl &&
        other.isPlaying == isPlaying;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        artist.hashCode ^
        songName.hashCode ^
        hexCode.hashCode ^
        songUrl.hashCode ^
        thumbnailUrl.hashCode ^
        isPlaying.hashCode;
  }
}
