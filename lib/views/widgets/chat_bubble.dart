import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motion_mix/constants.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
Widget chatBubble(DocumentSnapshot data){
  var t=data['created_on']==null ? DateTime.now():data['created_on'].toDate();
  var time=intl.DateFormat("h:mma").format(t);
  return  Directionality(
    textDirection: data['uid']==firebaseAuth.currentUser!.uid?TextDirection.rtl:TextDirection.ltr,
    // textDirection: TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 8),
      decoration:   BoxDecoration(
          color: data['uid']==firebaseAuth.currentUser!.uid?Colors.red:Colors.grey,
          borderRadius: data['uid']==firebaseAuth.currentUser!.uid? const BorderRadius.only(
            topLeft:Radius.circular(20),
            topRight:Radius.circular(20),
            bottomLeft:Radius.circular(20),
          ):const BorderRadius.only(
              topLeft:Radius.circular(20),
              topRight:Radius.circular(20),
              bottomRight: Radius.circular(20)
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "${data['msg']}".text.white.size(16).make(),
          10.heightBox,
          time.text.color(Colors.white.withOpacity(0.5)).make()
        ],
      ),
    ),
  );
}
