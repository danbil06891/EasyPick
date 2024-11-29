import 'dart:io';

import 'package:easy_pick/view/rider/requests/rider_request_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../repos/user_repo.dart';
import '../../../states/user_state.dart';

import '../../constants/color_constant.dart';
import '../profile/edit_profile.dart';
import '../widgets/custom_app_bar.dart';
import 'orders/rider_order_view.dart';

class RiderDashboard extends StatefulWidget {
  const RiderDashboard({super.key});

  @override
  State<RiderDashboard> createState() => _RiderDashboardState();
}

class _RiderDashboardState extends State<RiderDashboard> {
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
      const RiderOrderView(),
      const RiderRequestView(),
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
