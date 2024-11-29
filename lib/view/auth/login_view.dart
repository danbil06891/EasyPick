import 'package:easy_pick/view/rider/rider_dashboard.dart';
import 'package:easy_pick/view/shopkeeper/shop_keeper_dashboard.dart';
import 'package:easy_pick/view/user/user_dashboard.dart';
import 'package:flutter/material.dart';

import '../../constants/color_constant.dart';
import '../../repos/auth_repo.dart';
import '../../utills/local_storage.dart';
import '../../utills/snippets.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/loader_button.dart';
import 'components/forget_bottom_sheet.dart';
import 'components/rich_text.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Image.asset('assets/images/logo.png', height: 150, width: 150),
                const SizedBox(height: 70),
                CustomTextField(
                  maxLine: 1,
                  labelText: 'Email',
                  hintText: 'Email',
                  controller: emailController,
                  prefixIcon: Icons.email,
                  validator: emailValidator,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  maxLine: 1,
                  labelText: 'Password',
                  hintText: 'Password',
                  controller: passwordController,
                  prefixIcon: Icons.lock,
                  suffixIcon: Icons.visibility,
                  suffixIcon2: Icons.visibility_off,
                  validator: passwordValidator,
                ),
                const ForgetPasswordWidget(),
                const SizedBox(height: 50),
                LoaderButton(
                  btnText: 'Login',
                  onTap: () async {
                    try {
                      if (_formKey.currentState!.validate()) {
                        String? loginResponse = await AuthRepo.instance.login(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        String role = LocalStorage.getString(key: 'role');
                        if (!mounted) return;

                        if (loginResponse == 'Error') {
                          snack(context, 'An error occurred during login.',
                              info: false);
                        } else if (loginResponse == 'Not Found') {
                          snack(context, 'Invalid Email or Password.',
                              info: false);
                        } else if (loginResponse ==
                            'You are not approved by admin') {
                          snack(context, 'You are not approved by admin.',
                              info: false);
                        } else if (loginResponse ==
                            'You are blocked by admin') {
                          snack(context, 'You are blocked by admin.',
                              info: false);
                        } else if (role == 'User') {
                          replace(context, const UserDashboard());
                        } else if (role == 'Rider') {
                          replace(context, const RiderDashboard());
                        } else if (role == 'Shop Keeper') {
                          print('Shop Keeper');
                          replace(context, const ShopKeeperDashboard());
                        }
                      }
                    } catch (e) {
                      snack(context, e.toString(), info: false);
                    }
                  },
                ),
                const SizedBox(height: 100),
                RichTextWidget(
                    messageText: """Don't have an account?""",
                    titleText: '  Sign Up',
                    onTap: () {
                      push(context, const RegisterView());
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
