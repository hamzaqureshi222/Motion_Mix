import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:motion_mix/controllers/auth_controller.dart';
import 'package:motion_mix/views/screens/add_video_screen.dart';
import 'package:motion_mix/views/screens/messages_screen.dart';
import 'package:motion_mix/views/screens/profile_screen.dart';
import 'package:motion_mix/views/screens/search_screen.dart';
import 'package:motion_mix/views/screens/video_screen.dart';
import 'package:motion_mix/views/widgets/custom_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthController authController = Get.put(AuthController());

  int pageIdx = 0;

  List pages = [
    VideoScreen(),
    SearchScreen(),
    const AddVideoScreen(),
    const MessagesScreen(),
    ProfileScreen(
      uid: Get.find<AuthController>().user.uid,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: pageIdx == 0 ? Colors.black : Colors.white,
        selectedLabelStyle:
            TextStyle(color: pageIdx == 0 ? Colors.white : Colors.black),
        unselectedLabelStyle:
            TextStyle(color: pageIdx == 0 ? Colors.white : Colors.black),
        selectedIconTheme:
            IconThemeData(color: pageIdx == 0 ? Colors.white : Colors.black),
        unselectedItemColor: pageIdx == 0 ? Colors.white : Colors.black,
        currentIndex: pageIdx,
        items: [
          BottomNavigationBarItem(
            icon: Icon(pageIdx == 0 ?Icons.home:Icons.home_outlined, size: 30),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 30),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: CustomIcon(),
            label: '',
          ),
           BottomNavigationBarItem(
            icon: Icon(pageIdx ==3?Icons.message:Icons.messenger_outline, size: 30),
            label: 'Messages',
          ),
           BottomNavigationBarItem(
            icon: Icon(pageIdx ==4?Icons.person:Icons.person_outline, size: 30),
            label: 'Profile',
          ),
        ],
      ),
      body: pages[pageIdx],
    );
  }
}
