import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:password_strength/password_strength.dart';

import '../../../routes/app_pages.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});
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
                    final strength = estimatePasswordStrength(value!);
                    if (strength < 0.5) {
                      return 'Enter strong password!';
                    }

                    return null;
                  },
                ),

                // button
                FilledButton(
                  onPressed: () {
                    final formState = controller.formKey.currentState;
                    if (formState!.validate()) {
                      controller.signUp(
                        email: controller.emailController.text,
                        password: controller.passwordController.text,
                      );
                    }
                  },
                  child: Text('SignUp'),
                ),

                // sign up button
                TextButton(
                  onPressed: () => Get.offAllNamed(Routes.SIGNIN),
                  child: Text('Already have an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
