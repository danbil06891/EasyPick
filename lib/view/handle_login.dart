import 'package:easy_pick/view/rider/rider_dashboard.dart';
import 'package:easy_pick/view/shopkeeper/shop_keeper_dashboard.dart';
import 'package:easy_pick/view/user/user_dashboard.dart';
import 'package:flutter/material.dart';

import '../repos/auth_repo.dart';
import 'auth/login_view.dart';

class HandleLogin extends StatefulWidget {
  const HandleLogin({Key? key}) : super(key: key);

  @override
  State<HandleLogin> createState() => _HandleLoginState();
}

class _HandleLoginState extends State<HandleLogin> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: AuthRepo.instance.isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoginView();
          } else if (snapshot.data == 'User') {
            return const UserDashboard();
          } else if (snapshot.data == 'Rider') {
            return const RiderDashboard();
          } else if (snapshot.data == 'Shop Keeper') {
            return const ShopKeeperDashboard();
          } else {
            return const LoginView();
          }
        });
  }
}
