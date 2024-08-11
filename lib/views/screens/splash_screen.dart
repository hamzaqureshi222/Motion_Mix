import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_mix/views/screens/auth/login_screen.dart';
import 'package:motion_mix/views/screens/home_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      User ? user = auth.currentUser;
      // Get.to(const LoginScreen());
      if (user == null) {
        Get.to(LoginScreen());
      } else {
        Get.to(HomeScreen());
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            350.heightBox,
            Center(
                child: Image.asset("assets/icons/file.png",
                    width: context.screenWidth * 0.5)),
            20.heightBox,
            Text('Motion Mix',
                style: GoogleFonts.acme(color: Colors.grey, fontSize: 42))
          ],
        ),
      ),
    );
  }
}
