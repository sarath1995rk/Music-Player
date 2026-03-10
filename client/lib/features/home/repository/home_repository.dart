import 'dart:convert';
import 'dart:io';

import 'package:client/features/home/model/song_model.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:http/http.dart' as http;
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, SongModel>> uploadSong({
    required File song,
    required File thumbnail,
    required String artist,
    required String songName,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${ServerConstants.baseUrl}/api/song/upload"),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('song', song.path));
      request.files.add(
        await http.MultipartFile.fromPath('thumbnail', thumbnail.path),
      );
      request.fields['artist'] = artist;
      request.fields['songName'] = songName;
      request.fields['hexCode'] = hexCode;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(SongModel.fromMap(responseBody['song']));
      }

      return Left(AppFailure(responseBody['message']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs(String? token) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.baseUrl}/api/song/all"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Right(
          (responseBody['songs'] as List)
              .map((e) => SongModel.fromMap(e))
              .toList(),
        );
      }
      return Left(AppFailure(responseBody["message"]));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favouriteSong(
    String token,
    String songId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${ServerConstants.baseUrl}/api/song/favourite"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"songId": songId}),
      );
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Right(responseBody['isFavourite']);
      }
      return Left(AppFailure(responseBody["message"]));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllFavSongs(
    String? token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("${ServerConstants.baseUrl}/api/song/favourite"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );



      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Right(
          (responseBody['songs'] as List)
              .map((e) => SongModel.fromMap(e))
              .toList(),
        );
      }
      return Left(AppFailure(responseBody["message"]));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return Left(AppFailure(e.toString()));
    }
  }
}
