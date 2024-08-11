import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_mix/controllers/auth_controller.dart';
import 'package:motion_mix/controllers/search_controller.dart' as custom_search_controller;
import 'package:motion_mix/views/screens/profile_screen.dart';
import '../../models/user.dart';
import 'home_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  var controller = Get.put(custom_search_controller.SearchController());
 AuthController authContoller= Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.offAll(HomeScreen());
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Container(
          height: 45,
          child: TextFormField(
            style: TextStyle(color: Colors.white), // Change text color here
            decoration: const InputDecoration(
              fillColor: Colors.grey,
              filled: true,
              hintText: "Search",
              hintStyle: TextStyle(fontSize: 15, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
            ),
            onFieldSubmitted: (value) => controller.searchUser(value),
          ),
        ),
      ),
      body: Obx(
            () => ListView.builder(
          itemCount: controller.searchedUsers.length,
          itemBuilder: (context, index) {
            User user = controller.searchedUsers[index];
            return InkWell(
              onTap: () {
                Get.to(ProfileScreen(uid: user.uid,));
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: Uri.parse(user.profilePhoto).isAbsolute
                      ? NetworkImage(user.profilePhoto)
                      : AssetImage('assets/default_profile.png'),
                ),
                title: Text(user.name, style: const TextStyle(fontSize: 15, color: Colors.black)),
              ),
            );
          },
        ),
      ),
    );
  }
}
