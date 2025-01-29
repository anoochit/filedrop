import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: context.width * 0.8,
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // email
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    hintText: 'email',
                  ),
                ),

                // password
                TextFormField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    hintText: 'password',
                  ),
                  obscureText: true,
                ),

                // button
                FilledButton(
                  onPressed: () => controller.signIn(
                    email: controller.emailController.text,
                    password: controller.passwordController.text,
                  ),
                  child: Text('SignIn'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
