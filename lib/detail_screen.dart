import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DetailScreen extends StatelessWidget {
  final String imageUrl;

  DetailScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallpaper Detail'),
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _buildBottomSheet(context),
          );
        },
        child: Icon(Icons.wallpaper),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      height: 120,
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Set as Home Screen'),
            onTap: () async {
              await _setWallpaper(WallpaperManagerFlutter.HOME_SCREEN);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Set as Lock Screen'),
            onTap: () async {
              await _setWallpaper(WallpaperManagerFlutter.LOCK_SCREEN);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _setWallpaper(int location) async {
    try {
      // Download the image into a temporary directory
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        var documentDirectory = await getApplicationDocumentsDirectory();
        var filePath = '${documentDirectory.path}/temp_wallpaper.jpg';
        var file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Set the wallpaper
        await WallpaperManagerFlutter().setwallpaperfromFile(file, location);

        Get.snackbar('Success', 'Wallpaper set successfully');
      } else {
        throw 'Failed to download image';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to set wallpaper: $e');
    }
  }
}
