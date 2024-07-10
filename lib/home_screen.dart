import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaper_app/controller/home_controller.dart';
import 'package:wallpaper_app/detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final ScrollController gridScrollController = ScrollController();
  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wallpaper App',
          style: TextStyle(),
        ),
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification &&
                  scrollNotification.metrics.pixels ==
                      scrollNotification.metrics.maxScrollExtent) {
                homeController.fetchMoreWallpapers();
              }
              return false;
            },
            child: homeController.isGridView.value
                ? GridView.builder(
                    controller: gridScrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: homeController.wallpapers.length +
                        (homeController.isFetchingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == homeController.wallpapers.length) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => DetailScreen(
                                imageUrl:
                                    homeController.wallpapers[index].imageUrl,
                              ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: CachedNetworkImage(
                            imageUrl: homeController.wallpapers[index].imageUrl,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.grey[300],
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    controller: listScrollController,
                    itemCount: homeController.wallpapers.length +
                        (homeController.isFetchingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == homeController.wallpapers.length) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => DetailScreen(
                                imageUrl:
                                    homeController.wallpapers[index].imageUrl,
                              ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: CachedNetworkImage(
                            imageUrl: homeController.wallpapers[index].imageUrl,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.grey[300],
                                height: 200,
                                width: double.infinity,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                  ),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          if (homeController.isGridView.value) {
            homeController.gridScrollPosition.value =
                gridScrollController.offset;
          } else {
            homeController.listScrollPosition.value =
                listScrollController.offset;
          }

          
          homeController.toggleViewMode();

          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (homeController.isGridView.value) {
              gridScrollController
                  .jumpTo(homeController.gridScrollPosition.value);
            } else {
              listScrollController
                  .jumpTo(homeController.listScrollPosition.value);
            }
          });
        },
        child: Icon(Icons.swap_vert),
      ),
    );
  }
}
