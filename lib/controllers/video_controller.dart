import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:motion_mix/constants.dart';
import 'package:motion_mix/controllers/auth_controller.dart';
import 'package:motion_mix/models/video.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final videoUrls = prefs.getStringList('videoUrls');

      if (videoUrls != null && videoUrls.isNotEmpty) {
        List<Video> cachedVideos = [];

        for (String id in videoUrls) {
          DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
          if (doc.exists) {
            cachedVideos.add(Video.fromSnap(doc));
          }
        }
        _videoList.value = cachedVideos;
      }

      // Always listen for real-time updates
      firestore.collection('videos').orderBy('timestamp', descending: true).snapshots().listen((QuerySnapshot query) async {
        List<Video> retVal = [];
        List<String> urls = [];
        for (var element in query.docs) {
          Video video = Video.fromSnap(element);
          retVal.add(video);
          urls.add(video.id); // Assuming `id` is the document ID
        }
        _videoList.value = retVal;
        await prefs.setStringList('videoUrls', urls);
      });

    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch videos: $e');
      if (kDebugMode) {
        print('Error fetching videos: $e');
      }
    }
  }

  Future<void> likeVideo(String id) async {
    var uid = Get.find<AuthController>().user.uid;
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    List likes = (doc.data()! as dynamic)['likes'];

    if (likes.contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }

    // Fetch updated video data and update the list
    doc = await firestore.collection('videos').doc(id).get();
    Video updatedVideo = Video.fromSnap(doc);
    int index = _videoList.value.indexWhere((video) => video.id == id);
    if (index != -1) {
      _videoList.value[index] = updatedVideo;
      _videoList.refresh();
    }
  }

  Future<void> bookmarkVideo(String id) async {
    var uid = Get.find<AuthController>().user.uid;
    DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
    List bookmarks = (doc.data()! as dynamic)['bookmarks'];

    if (bookmarks.contains(uid)) {
      await firestore.collection('videos').doc(id).update({
        'bookmarks': FieldValue.arrayRemove([uid]),
      });
    } else {
      await firestore.collection('videos').doc(id).update({
        'bookmarks': FieldValue.arrayUnion([uid]),
      });
    }

    // Fetch updated video data and update the list
    doc = await firestore.collection('videos').doc(id).get();
    Video updatedVideo = Video.fromSnap(doc);
    int index = _videoList.value.indexWhere((video) => video.id == id);
    if (index != -1) {
      _videoList.value[index] = updatedVideo;
      _videoList.refresh();
    }
  }
}
