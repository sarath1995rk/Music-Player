import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/viewmodel/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.read(currentSongProvider.notifier);
    final userFavorites = ref
        .watch(currentUserProvider.select((data) => data!.favorites))
        .map((fav) => fav.songId)
        .toList();

    if (currentSong == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(int.parse('0xFF${currentSong.hexCode}')),
            Color(0xff121212),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: Pallete.transparentColor,
              focusColor: Pallete.transparentColor,
              splashColor: Pallete.transparentColor,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 15,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Hero(
                  tag: "music-image",
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnailUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.songName,
                              style: TextStyle(
                                fontSize: 24,
                                color: Pallete.whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              currentSong.artist,
                              style: TextStyle(
                                fontSize: 16,
                                color: Pallete.subtitleText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: const SizedBox()),
                        IconButton(
                          onPressed: () {
                            ref
                                .read(homeViewModelProvider.notifier)
                                .favSong(songId: currentSong.id);
                          },
                          icon: Icon(
                            userFavorites.contains(currentSong.id)
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            color: Pallete.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            StreamBuilder(
              stream: songNotifier.audioPlayer!.positionStream,

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                final position = snapshot.data;
                final duration = songNotifier.audioPlayer?.duration;
                if (position == null || duration == null) {
                  return const SizedBox.shrink();
                }
                var sliderValue =
                    position.inMilliseconds / duration.inMilliseconds;
                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Pallete.whiteColor,
                        inactiveTrackColor: Pallete.whiteColor.withOpacity(
                          0.117,
                        ),
                        thumbColor: Pallete.whiteColor,
                        trackHeight: 4,
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: Slider(
                        value: sliderValue,
                        min: 0,
                        max: 1,
                        onChanged: (value) {
                          sliderValue = value;
                        },
                        onChangeEnd: (value) {
                          songNotifier.seek(value);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${position.inMinutes}:${position.inSeconds < 10 ? '0${position.inSeconds}' : position.inSeconds}',
                          style: const TextStyle(
                            color: Pallete.subtitleText,
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          '${duration.inMinutes}:${duration.inSeconds < 10 ? '0${duration.inSeconds}' : duration.inSeconds}',
                          style: const TextStyle(
                            color: Pallete.subtitleText,
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/shuffle.png',
                    color: Pallete.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/previus-song.png',
                    color: Pallete.whiteColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    songNotifier.playPause();
                  },
                  icon: Icon(
                    currentSong.isPlaying == true
                        ? CupertinoIcons.pause_circle_fill
                        : CupertinoIcons.play_circle_fill,
                  ),
                  iconSize: 80,
                  color: Pallete.whiteColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/next-song.png',
                    color: Pallete.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/repeat.png',
                    color: Pallete.whiteColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/connect-device.png',
                    color: Pallete.whiteColor,
                  ),
                ),
                const Expanded(child: SizedBox()),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/playlist.png',
                    color: Pallete.whiteColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
