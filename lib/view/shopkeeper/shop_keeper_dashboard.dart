import 'dart:io';

import 'package:easy_pick/utills/snippets.dart';
import 'package:easy_pick/view/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../repos/user_repo.dart';
import '../../../states/user_state.dart';
import '../../components/dialog_widget.dart';
import '../../constants/color_constant.dart';
import '../profile/edit_profile.dart';
import 'orders/shop_order_view.dart';
import 'menu/menu_view.dart';
import 'view_user_request/shop_view_user_request.dart';

class ShopKeeperDashboard extends StatefulWidget {
  const ShopKeeperDashboard({super.key});

  @override
  State<ShopKeeperDashboard> createState() => _ShopKeeperDashboardState();
}

class _ShopKeeperDashboardState extends State<ShopKeeperDashboard> {
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
      const ShopHomeview(),
      const MenuView(),
      const ShopKeeperUserRequestView(),
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
                icon: Icon(FontAwesomeIcons.box, size: 30), label: 'Order'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.cubesStacked), label: 'Menu'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.hand), label: 'Request'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget selectImage() {
    return Stack(
      children: [
        uploadImage == null
            ? const CircleAvatar(
                radius: 58,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              )
            : CircleAvatar(
                backgroundImage: FileImage(uploadImage!),
                radius: 58,
              ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Card(
            shape: getRoundShape(),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                showDialogOf(context, ImageDialogWidget(
                  onClick: (ref) async {
                    Navigator.of(context).pop();
                    if (ref.toString().contains("camera")) {
                      uploadImage = await pickImage(ImageSource.camera);
                    } else {
                      uploadImage = await pickImage(ImageSource.gallery);
                    }
                    setState(() {});
                  },
                ));
              },
            ),
          ),
        ),
      ],
    );
  }
}
