import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:motion_mix/controllers/auth_controller.dart';
import 'package:motion_mix/views/screens/auth/signup_screen.dart';
import 'package:motion_mix/views/widgets/text_input_field.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Motion Mix',
                style: GoogleFonts.acme(color: buttonColor, fontSize: 42)),
            Text('Login', style: GoogleFonts.acme(fontSize: 25)),
            25.heightBox,
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
            25.heightBox,
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                isObscure: true,
                controller: _passwordController,
                labelText: "Password",
                icon: Icons.lock,
              ),
            ),
            30.heightBox,
            Obx(() => InkWell(
              onTap: authController.isLoading.value
                  ? null
                  : () {
                authController.loginUser(
                    _emailController.text, _passwordController.text);
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(8))),
                child: authController.isLoading.value
                    ? Align(
                    alignment: Alignment.center,
                    child: LoadingAnimationWidget.discreteCircle(color: Colors.white, size: 35)): "Login".text.white.size(16).bold.makeCentered(),
              ),
            )),
            15.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                'Dont have an account'.text.size(16).make(),
                7.widthBox,
                'SignIn'.text.color(Colors.red).size(15).bold.make().onTap(() {
                  Get.to(SignupScreen());
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}

