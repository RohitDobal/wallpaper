import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  var wallpapers = <Wallpaper>[].obs;
  var isLoading = true.obs;
  var isFetchingMore = false.obs;
  var page = 1;
  final String accessKey = 'JtnqJrkLVabUGdVmIAgiJoZz901iqD_tSYwQeQFL67Y';
  var isGridView = true.obs; 
  var gridScrollPosition =
      0.0.obs; 
  var listScrollPosition =
      0.0.obs; 

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
        List<Wallpaper> newWallpapers = [];

        for (var item in jsonResponse) {
          Wallpaper wallpaper = Wallpaper.fromJson(item);
          newWallpapers.add(wallpaper);
        }
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
        List<Wallpaper> newWallpapers = [];

        for (var item in jsonResponse) {
          Wallpaper wallpaper = Wallpaper.fromJson(item);
          newWallpapers.add(wallpaper);
        }

        for (var newWallpaper in newWallpapers) {
          
          if (!wallpapers.any(
              (existingWallpaper) => existingWallpaper.id == newWallpaper.id)) {
            
            wallpapers.add(newWallpaper);
          }
        }
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
