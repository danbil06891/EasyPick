import 'dart:io';

import 'package:easy_pick/view/user/request/user_request_view.dart';
import 'package:easy_pick/view/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../repos/user_repo.dart';
import '../../../states/user_state.dart';
import '../../constants/color_constant.dart';
import '../profile/edit_profile.dart';

import 'home/user_home_view.dart';
import 'order/user_order_view.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int pageIndex = 0;
  File? uploadImage;
  @override
  void initState() {
    super.initState();
    _getUserInfo(context: context);
  }

  _getUserInfo({required BuildContext context}) async {
    final userProvider = Provider.of<UserState>(context, listen: false);
    UserModel? user = await UserRepo.instance
        .getUserDetail(FirebaseAuth.instance.currentUser!.uid);
    if (user != null) {
      userProvider.setUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const UserHomeView(),
      const UserOrdersView(),
      const UserRequestView(),
      const EditProfileView()
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
          showLeading: false, title: context.watch<UserState>().userModel.name),
      body: pages.elementAt(pageIndex),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: secondaryColor,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          currentIndex: pageIndex,
          unselectedFontSize: 13,
          selectedFontSize: 13,
          onTap: (index) {
            if (mounted) {
              setState(() {
                pageIndex = index;
              });
            }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.house, size: 30), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.box, size: 30), label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.hand), label: 'Requests'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
