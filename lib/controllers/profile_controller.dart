import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:motion_mix/constants.dart';
import 'package:motion_mix/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = "".obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    var myvideos = await firestore
        .collection("videos")
        .where("uid", isEqualTo: _uid.value)
        .get();

    DocumentSnapshot userDoc =
        await firestore.collection("users").doc(_uid.value).get();
    final userData = userDoc.data() as dynamic;
    String name = userData["name"];
    String profilePhoto = userData["profilePhoto"];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    for (var item in myvideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }

    var followerDoc = await firestore
        .collection("users")
        .doc(_uid.value)
        .collection("followers")
        .get();
    var followingDoc = await firestore
        .collection("users")
        .doc(_uid.value)
        .collection("following")
        .get();
    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    firestore
        .collection("users")
        .doc(_uid.value)
        .collection("followers")
        .doc(Get.find<AuthController>().user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }

      _user.value = {
        "followers": followers.toString(),
        "following": following.toString(),
        "isFollowing": isFollowing,
        "likes": likes.toString(),
        "profilePhoto": profilePhoto,
        "name": name
      };
      update();
    });
  }

  followUser() async {
    String uid = Get.find<AuthController>().user.uid;
    var doc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection("followers")
        .doc(uid)
        .get();
    if (!doc.exists) {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection("followers")
          .doc(uid)
          .set({});
      await firestore
          .collection('users')
          .doc(uid)
          .collection("following")
          .doc(_uid.value)
          .set({});
      _user.value
          .update("followers", (value) => (int.parse(value) + 1).toString());
    } else {
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection("followers")
          .doc(uid)
          .delete();
      await firestore
          .collection('users')
          .doc(uid)
          .collection("following")
          .doc(_uid.value)
          .delete();
      _user.value
          .update("followers", (value) => (int.parse(value) - 1).toString());
    }
    _user.value.update("isFollowing", (value) => !value);
    update();
  }
  Stream<QuerySnapshot> getAllMessages() {
      return firestore.collection("chats")
          .where('userIds', arrayContains: firebaseAuth.currentUser!.uid)
          .snapshots();
    }
}
