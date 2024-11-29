import 'package:easy_pick/repos/item_repo.dart';
import 'package:easy_pick/view/shopkeeper/menu/add_item_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/color_constant.dart';
import '../../../constants/theme_constant.dart';
import '../../../models/item_model.dart';
import '../../../utills/snippets.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            StreamBuilder(
                stream: ItemRepo.instance
                    .getAllShopItem(id: FirebaseAuth.instance.currentUser!.uid),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            push(context, const AddItemPopup());
          },
          child: const Icon(Icons.add),
        ));
  }
}
