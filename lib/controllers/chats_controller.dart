import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:motion_mix/constants.dart';

class ChatsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initializeController();
  }

  var chats = FirebaseFirestore.instance.collection("chats");
  var senderName = "".obs;
  var currentId = firebaseAuth.currentUser!.uid;
  var msgController = TextEditingController();
  var isLoading = false.obs;
  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];
  var chatDocId = Rxn<String>();

  void initializeController() async {
    isLoading(true);
    await getUsername();
    await getChatId();
    isLoading(false);
  }

  Future<void> getChatId() async {
    await chats.where('userIds', arrayContains: currentId).limit(1).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          List userIds = doc['userIds'];
          if (userIds.contains(friendId)) {
            chatDocId.value = doc.id;
          }
        }
      }
      if (chatDocId.value == null) {
        chats.add({
          'created_on': FieldValue.serverTimestamp(),
          'last_msg': '',
          'userIds': [friendId, currentId],
          'toId': '',
          'fromId': '',
          'friendname': friendName,
          'sendername': senderName.value,
        }).then((value) {
          chatDocId.value = value.id;
        });
      }
    });
  }

  Future<void> getUsername() async {
    DocumentSnapshot userDoc = await firestore.collection("users").doc(firebaseAuth.currentUser!.uid).get();
    final userData = userDoc.data() as Map<String, dynamic>;
    String name = userData["name"];
    senderName.value = name;
  }

  void sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      await chats.doc(chatDocId.value).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': currentId,
        'fromId': friendId,
      });
      await chats.doc(chatDocId.value).collection("messages").doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId
      });
    }
  }

  static Stream<QuerySnapshot> getMessages(String? docId) {
    return firestore.collection("chats").doc(docId)
        .collection("messages").orderBy('created_on', descending: true).snapshots();
  }
}
