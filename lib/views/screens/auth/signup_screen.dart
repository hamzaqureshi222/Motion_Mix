import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:motion_mix/constants.dart';
import 'package:motion_mix/controllers/auth_controller.dart';
import 'package:motion_mix/views/widgets/text_input_field.dart';
import 'package:velocity_x/velocity_x.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthController authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Motion Mix',
                  style: GoogleFonts.acme(color: buttonColor, fontSize: 42)),
              Text('Register', style: GoogleFonts.acme(fontSize: 25)),
              10.heightBox,
              Obx(() {
                return Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: authController.profilePhoto != null
                          ? FileImage(authController.profilePhoto!)
                          : const AssetImage("assets/icons/images.png")
                      as ImageProvider,
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () {
                          authController.pickImage();
                        },
                        icon: const Icon(Icons.add_a_photo, color: Colors.white),
                      ),
                    ),
                  ],
                );
              }),
              15.heightBox,
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _usernameController,
                  labelText: "Username",
                  icon: Icons.person,
                ),
              ),
              15.heightBox,
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _emailController,
                  labelText: "Email",
                  icon: Icons.email,
                ),
              ),
              15.heightBox,
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _passwordController,
                  icon: Icons.lock,
                  labelText: "Password",
                  isObscure: true,
                ),
              ),
              35.heightBox,
              Obx(() {
                return InkWell(
                  onTap: authController.isLoading.value
                      ? null
                      : () {
                    authController.registerUser(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                      authController.profilePhoto,
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: authController.isLoading.value
                        ? Align(
                        alignment: Alignment.center,
                        child: LoadingAnimationWidget.discreteCircle(color: Colors.white, size: 35))
                        : "Register".text.white.size(16).bold.makeCentered(),
                  ),
                );
              }),
              12.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  70.widthBox,
                  'Already have an account'.text.size(16).make(),
                  7.widthBox,
                  'LogIn'
                      .text
                      .color(Colors.red)
                      .size(15)
                      .bold
                      .make()
                      .onTap(() {
                    Get.back();
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

