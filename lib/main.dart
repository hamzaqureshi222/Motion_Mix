import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_mix/constants.dart';
import 'package:motion_mix/controllers/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:motion_mix/views/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Motion Mix',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: backgroundColor),
        home: const SplashScreen());
  }
}
