import 'package:api_tutorial_api/Screens/Videos/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<String> _favoriteVideos = [];
  final Map<String, String> _videoTitles = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Method to load favorite video ids and titles from shared preferences
  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteVideos = prefs.getStringList('favorites') ?? [];
    });
    // Fetch video titles based on video ids
    _fetchVideoTitles();
  }

  // Method to fetch video titles based on video ids
  void _fetchVideoTitles() {
    for (String favorite in _favoriteVideos) {
      // Split the stored string to get video ID and title
      List<String> parts = favorite.split('|');
      String videoId = parts[0];
      String videoTitle = parts[1];

      // Update the video titles map
      _videoTitles[videoId] = videoTitle;
    }
    // Update the state to rebuild the UI with dynamic video titles
    setState(() {});
  }

  // Method to remove a video from favorites
  void _removeFromFavorites(String videoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList('favorites') ?? [];
    favorites.removeWhere((item) => item.split('|')[0] == videoId);
    prefs.setStringList('favorites', favorites);
    setState(() {
      _favoriteVideos.removeWhere((item) => item.split('|')[0] == videoId);
      _videoTitles.remove(videoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 178, 234),
      body: _favoriteVideos.isEmpty
          ? const Center(
              child: Text('No favorite videos yet.'),
            )
          : ListView.builder(
              itemCount: _favoriteVideos.length,
              itemBuilder: (context, index) {
                String videoId = _favoriteVideos[index].split('|')[0];
                return _buildFavoriteVideoItem(videoId);
              },
            ),
    );
  }

  Widget _buildFavoriteVideoItem(String videoId) {
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';
    final videoTitle = _videoTitles[videoId] ?? '';

    return Dismissible(
      key: Key(videoId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      onDismissed: (direction) {
        _removeFromFavorites(videoId);
      },
      child: GestureDetector(
        onTap: () {
          // Navigate to VideoPlayerScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                videoId: videoId,
                videoTitle: videoTitle,
                videoViews: '', // Add appropriate value
                videoDuration: '', // Add appropriate value
                fromFavorites: true,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.9),
                spreadRadius: 4,
                blurRadius: 3,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  thumbnailUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 40),
                      ),
                    );
                  },
                ),
              ),
              const Divider(
                thickness: 3,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  videoTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
