import 'package:easy_pick/constants/theme_constant.dart';
import 'package:easy_pick/states/cart_state.dart';
import 'package:easy_pick/states/map_state.dart';
import 'package:easy_pick/states/register_state.dart';
import 'package:easy_pick/states/shop_state.dart';
import 'package:easy_pick/states/user_state.dart';
import 'package:easy_pick/utills/local_storage.dart';
import 'package:easy_pick/view/splash/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RegisterState()),
        ChangeNotifierProvider(create: (context) => UserState()),
        ChangeNotifierProvider(create: (context) => MapState()),
        ChangeNotifierProvider(create: (context) => UserState()),
        ChangeNotifierProvider(create: (context) => ShopState()),
        ChangeNotifierProvider(create: (context) => CartState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: getTheme(),
      home: const SplashView(),
    );
  }
}
