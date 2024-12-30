// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String videoTitle;
  final String videoViews;
  final String videoDuration;
  final bool fromFavorites; // New parameter

  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    required this.videoTitle,
    required this.videoViews,
    required this.videoDuration,
    this.fromFavorites = false,
  });

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isFavorited = false;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    _controller.addListener(() {
      setState(() {
        _isFullScreen = _controller.value.isFullScreen;
      });
    });
    _checkFavoriteStatus(); // Check favorite status on initialization
  }

  // Method to check and set favorite status from shared preferences
  void _checkFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      _isFavorited =
          favorites.any((item) => item.split('|')[0] == widget.videoId);
    });
  }

  // Method to save video details to shared preferences
  void _saveToFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites') ?? [];
    String videoData = '${widget.videoId}|${widget.videoTitle}';

    if (!_isFavorited) {
      favorites.add(videoData);
    } else {
      favorites.removeWhere((item) => item.split('|')[0] == widget.videoId);
    }
    prefs.setStringList('favorites', favorites);
    setState(() {
      _isFavorited = !_isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 178, 234),
      appBar: !_isFullScreen
          ? AppBar(
              backgroundColor: Colors.blue,
              title: const Text(
                'AP Tutorials',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            )
          : null,
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {},
          progressIndicatorColor: Colors.blue,
          progressColors: const ProgressBarColors(
            playedColor: Colors.blue,
            handleColor: Colors.blueAccent,
          ),
        ),
        builder: (context, player) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              player,
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
                child: Text(
                  widget.videoTitle,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(
                thickness: 2,
                color: Colors.black,
              ),
              if (!widget.fromFavorites)
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.remove_red_eye,
                              size: 19, color: Colors.black),
                          Text(
                            widget.videoViews,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: _isFavorited
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 30,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                size: 30,
                              ),
                        color: Colors.red,
                        onPressed: _saveToFavorites,
                      ),
                    ],
                  ),
                ),
              if (!widget.fromFavorites)
                const Divider(
                  thickness: 2,
                  color: Colors.black,
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
