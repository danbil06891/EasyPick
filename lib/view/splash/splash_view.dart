import 'package:flutter/material.dart';

import '../../constants/color_constant.dart';
import '../../utills/snippets.dart';
import '../handle_login.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      replace(context, const HandleLogin());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Image.asset('assets/images/logo.png', height: 200, width: 200),
      ),
    );
  }
}
