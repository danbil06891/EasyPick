import 'package:easy_pick/models/item_model.dart';
import 'package:easy_pick/repos/item_repo.dart';
import 'package:easy_pick/states/cart_state.dart';
import 'package:easy_pick/utills/snippets.dart';
import 'package:easy_pick/view/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../constants/color_constant.dart';
import '../../../../constants/theme_constant.dart';
import '../../../../models/user_model.dart';

class ShopProductsView extends StatefulWidget {
  final UserModel userModel;
  const ShopProductsView({super.key, required this.userModel});

  @override
  State<ShopProductsView> createState() => _ShopProductsViewState();
}

class _ShopProductsViewState extends State<ShopProductsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(
        title: 'Shop Products',
        showLeading: true,
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream:
                  ItemRepo.instance.getAllShopItem(id: widget.userModel.uid),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: getLoader());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('No Data Found'));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      ItemModel model = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 10,
                          color: backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 21,
                              backgroundImage: NetworkImage(
                                model.image,
                              ),
                            ),
                            title: Text(
                              model.name,
                              style: CustomFont.regularText
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(
                                  Icons.abc,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    model.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomFont.lightText.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Text(
                                  "${snapshot.data![index].price} Rs/-",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    final cartState = Provider.of<CartState>(
                                        context,
                                        listen: false);
                                    cartState.addToCart(model);
                                  },
                                  child: const Icon(
                                    Icons.add_circle_outline,
                                    color: secondaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
