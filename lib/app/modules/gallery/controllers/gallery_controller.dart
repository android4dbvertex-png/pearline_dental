import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:pearline_dental/app/core/constants/app_constants.dart';

class GalleryController extends GetxController {
  final _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  final photos = <Map<String, dynamic>>[].obs;
  final videos = <Map<String, dynamic>>[].obs;
  final isLoadingPhotos = false.obs;
  final isLoadingVideos = false.obs;
  final selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPhotos();
    fetchVideos();
  }

  Future<void> fetchPhotos() async {
    try {
      isLoadingPhotos.value = true;
      final response = await _dio.get(ApiEndpoints.gallery);
      if (response.data['success'] == true) {
        photos.value = List<Map<String, dynamic>>.from(response.data['data']);
      }
    } catch (e) {
      print('Photos Error: $e');
    } finally {
      isLoadingPhotos.value = false;
    }
  }

  Future<void> fetchVideos() async {
    try {
      isLoadingVideos.value = true;
      final response = await _dio.get(ApiEndpoints.videos);
      if (response.data['success'] == true) {
        videos.value = List<Map<String, dynamic>>.from(response.data['data']);
      }
    } catch (e) {
      print('Videos Error: $e');
    } finally {
      isLoadingVideos.value = false;
    }
  }

  void changeTab(int index) => selectedTab.value = index;

  String getYoutubeId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.first;
    }
    return uri.queryParameters['v'] ?? '';
  }

  String getYoutubeThumbnail(String url) {
    final id = getYoutubeId(url);
    return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
  }
}
