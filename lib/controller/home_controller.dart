import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  var wallpapers = <Wallpaper>[].obs;
  var isLoading = true.obs;
  var isFetchingMore = false.obs;
  var page = 1;
  final String accessKey = 'JtnqJrkLVabUGdVmIAgiJoZz901iqD_tSYwQeQFL67Y';
  var isGridView = true.obs; // Observable variable to track view mode
  var gridScrollPosition =
      0.0.obs; // Observable variable to store grid scroll position
  var listScrollPosition =
      0.0.obs; // Observable variable to store list scroll position

  @override
  void onInit() {
    super.onInit();
    fetchWallpapers();
  }

  Future<void> fetchWallpapers() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(
          'https://api.unsplash.com/photos?client_id=$accessKey&page=$page'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body) as List;
        var newWallpapers =
            jsonResponse.map((item) => Wallpaper.fromJson(item)).toList();
        wallpapers.assignAll(newWallpapers);
      } else {
        Get.snackbar('Error', 'Failed to fetch wallpapers');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMoreWallpapers() async {
    if (isFetchingMore.value) return;

    try {
      isFetchingMore(true);
      page++;
      var response = await http.get(Uri.parse(
          'https://api.unsplash.com/photos?client_id=$accessKey&page=$page'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body) as List;
        var newWallpapers =
            jsonResponse.map((item) => Wallpaper.fromJson(item)).toList();
        wallpapers.addAll(newWallpapers.where((newWallpaper) => !wallpapers.any(
            (existingWallpaper) => existingWallpaper.id == newWallpaper.id)));
      } else {
        Get.snackbar('Error', 'Failed to fetch more wallpapers');
      }
    } finally {
      isFetchingMore(false);
    }
  }

  void toggleViewMode() {
    isGridView.value = !isGridView.value;
  }
}

class Wallpaper {
  final String id;
  final String imageUrl;

  Wallpaper({required this.id, required this.imageUrl});

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
      id: json['id'],
      imageUrl: json['urls']['small'],
    );
  }
}
