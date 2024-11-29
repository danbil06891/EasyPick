import 'package:easy_pick/states/user_state.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import '../../constants/color_constant.dart';
import '../../states/cart_state.dart';
import '../../utills/snippets.dart';
import '../user/cart/cart_view.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeading;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.showLeading,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.showLeading,
      elevation: 0,
      backgroundColor: secondaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(widget.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18)),
      actions: [
        context.watch<UserState>().userModel.type == 'User'
            ? Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      push(context, const CartView());
                    },
                    icon: const Icon(
                      FontAwesomeIcons.cartShopping,
                      color: whiteColor,
                      size: 25,
                    ),
                  ),
                  if (context.watch<CartState>().cartItemCount > 0)
                    Positioned(
                      top: 2,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          // push(context, const CartView());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                              context
                                  .watch<CartState>()
                                  .cartItemCount
                                  .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: whiteColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  )),
                        ),
                      ),
                    ),
                ],
              )
            : Container(),
      ],
    );
  }
}
