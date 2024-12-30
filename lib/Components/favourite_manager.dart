import 'package:shared_preferences/shared_preferences.dart';

class FavoriteManager {
  static final FavoriteManager _instance = FavoriteManager._internal();
  factory FavoriteManager() => _instance;

  late SharedPreferences _prefs;
  late List<String> favoriteVideoIds;

  FavoriteManager._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    favoriteVideoIds = _prefs.getStringList('favoriteVideoIds') ?? [];
  }

  void toggleFavorite(String videoId) {
    if (favoriteVideoIds.contains(videoId)) {
      favoriteVideoIds.remove(videoId);
    } else {
      favoriteVideoIds.add(videoId);
    }
    _saveFavorites();
  }

  void _saveFavorites() {
    _prefs.setStringList('favoriteVideoIds', favoriteVideoIds);
  }

  bool isFavorite(String videoId) {
    return favoriteVideoIds.contains(videoId);
  }
}
