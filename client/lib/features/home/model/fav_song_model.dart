class FavouriteSongModel {
  final int id;
  final int userId;
  final String songId;

  FavouriteSongModel({
    required this.id,
    required this.userId,
    required this.songId,
  });

  factory FavouriteSongModel.fromMap(Map<String, dynamic> map) {
    return FavouriteSongModel(
      id: map['id'] as int,
      userId: map['userId'] as int,
      songId: map['songId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'userId': userId, 'songId': songId};
  }
}
