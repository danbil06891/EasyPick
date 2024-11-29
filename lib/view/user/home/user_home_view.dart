import 'package:easy_pick/components/no_data_component.dart';
import 'package:easy_pick/constants/color_constant.dart';
import 'package:easy_pick/constants/theme_constant.dart';
import 'package:easy_pick/models/user_model.dart';
import 'package:easy_pick/repos/shop_repo.dart';
import 'package:easy_pick/states/user_state.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../utills/snippets.dart';
import 'shop_products/shop_products_view.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  final radiusController = TextEditingController();
  int radius = 10;
  @override
  initState() {
    super.initState();
    radiusController.text = radius.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            children: [
              TextField(
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.black),
                controller: radiusController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: greyColor, fontSize: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: textFieldColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: textFieldColor),
                  ),
                  isDense: true,
                  filled: true,
                  hintText: 'Enter Radius',
                ),
                onSubmitted: (value) {
                  setState(() {
                    radius = int.parse(value);
                  });
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder<List<UserModel>>(
                stream: ShopRepo.instance.getAllUsersByGeoPackage(
                    userModel: context.watch<UserState>().userModel,
                    rad: radius),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text(snapshot.error.toString());
                  if (!snapshot.hasData) {
                    return const NoDataComponent();
                  }
                  return snapshot.data!.isEmpty
                      ? const Expanded(child: NoDataComponent())
                      : Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              UserModel? model = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Card(
                                  color: backgroundColor,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      push(context,
                                          ShopProductsView(userModel: model));
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 21,
                                        backgroundImage: NetworkImage(
                                          model.imageUrl,
                                        ),
                                      ),
                                      title: Text(
                                        model.shopName ?? '',
                                        style: CustomFont.regularText.copyWith(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              model.address,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: CustomFont.lightText
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                },
              )
            ],
          ),
        ));
  }
}
