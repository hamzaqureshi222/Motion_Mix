import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motion_mix/constants.dart';
import 'package:motion_mix/controllers/chats_controller.dart';
import 'package:motion_mix/controllers/profile_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_screen.dart';
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController=Get.put(ProfileController());
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: 'Messages'.text.semiBold.color(Colors.black).make(),
      ),
      body: StreamBuilder(
          stream:profileController.getAllMessages(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return  const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.black)),);
            }else if(snapshot.data!.docs.isEmpty){
              return 'No Messages yet'.text.color(Colors.black).makeCentered();
            }else{
              var data=snapshot.data!.docs;
              return Column(
                children: [
                  Expanded(child:
                  ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context,int index){
                        return Card(
                          color: Colors.white12,
                          child: ListTile(
                            onTap: (){
                              data[index]['toId']==firebaseAuth.currentUser!.uid?
                              Get.to(  const ChatScreen(),arguments: [
                                data[index]['friendname'],data[index]['toId']
                              ]):Get.to( ChatScreen(),arguments: [
                                data[index]['sendername'],data[index]['toId']
                              ]);
                            },
                            leading: const CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Icon(Icons.person,color: Colors.white,),
                            ),
                            title:  data[index]['toId']==firebaseAuth.currentUser!.uid?'${data[index]['friendname']}'.text.semiBold.color(Colors.black).make()
                                :'${data[index]['sendername']}'.text.semiBold.color(Colors.black).make(),
                            subtitle: '${data[index]['last_msg']}'.text.color(Colors.black).make(),
                          ),
                        );
                      }))
                ],
              );
            }
          }),
    );
  }
}
