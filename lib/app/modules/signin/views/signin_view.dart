import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
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
                  validator: (value) {
                    if (!GetUtils.isEmail(value!)) {
                      return 'Enter email';
                    }

                    return null;
                  },
                ),

                // password
                TextFormField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    hintText: 'password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter password';
                    }

                    return null;
                  },
                ),

                // sign in button
                FilledButton(
                  onPressed: () {
                    final formState = controller.formKey.currentState;
                    if (formState!.validate()) {
                      controller.signIn(
                        email: controller.emailController.text,
                        password: controller.passwordController.text,
                      );
                    }
                  },
                  child: Text('SignIn'),
                ),

                // sign up button
                TextButton(
                  onPressed: () => Get.offAllNamed(Routes.SIGNUP),
                  child: Text('Don\'t have an account?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
