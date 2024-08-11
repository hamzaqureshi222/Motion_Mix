import 'dart:developer';

import 'package:motion_mix/constants.dart';
import 'package:motion_mix/views/widgets/chat_bubble.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../controllers/chats_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    ChatsController chatsController = Get.put(ChatsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
            chatsController.friendName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: Obx(() {
        if (chatsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (chatsController.chatDocId.value == null) {
          return const Center(
              child: Text('No chat found', style: TextStyle(color: Colors.black)));
        } else {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: ChatsController.getMessages(chatsController.chatDocId.value),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator(color: Colors.grey));
                      } else if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text('No messages yet',
                                style: TextStyle(color: Colors.black)));
                      } else {
                        var data = snapshot.data!.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var message = data[index];
                            return Align(
                              alignment: message['uid'] == firebaseAuth.currentUser!.uid
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: chatBubble(message),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: chatsController.msgController,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        chatsController.sendMsg(chatsController.msgController.text);
                        chatsController.msgController.clear();
                      },
                      icon: const Icon(Icons.send, color: Colors.white),
                    )
                        .box
                        .color(Colors.black45)
                        .roundedFull
                        .margin(const EdgeInsets.only(left: 5))
                        .make(),
                  ],
                )
                    .box
                    .height(70)
                    .padding(const EdgeInsets.all(12))
                    .margin(const EdgeInsets.only(bottom: 2))
                    .make(),
              ],
            ),
          );
        }
      }),
    );
  }
}
