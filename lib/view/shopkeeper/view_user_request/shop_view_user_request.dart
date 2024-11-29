import 'dart:developer';
import 'package:easy_pick/models/product_request_model.dart';
import 'package:easy_pick/repos/product_repo.dart';
import 'package:easy_pick/view/shopkeeper/view_user_request/shop_request_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../components/no_data_component.dart';
import '../../../constants/color_constant.dart';
import '../../../models/user_model.dart';
import '../../../repos/user_repo.dart';
import '../../../states/user_state.dart';
import '../../../utills/snippets.dart';

class ShopKeeperUserRequestView extends StatefulWidget {
  const ShopKeeperUserRequestView({super.key});

  @override
  State<ShopKeeperUserRequestView> createState() =>
      _ShopKeeperUserRequestViewState();
}

class _ShopKeeperUserRequestViewState extends State<ShopKeeperUserRequestView> {
  @override
  Widget build(BuildContext context) {
    log('WorkersRequestView build');
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              StreamBuilder<List<ProductRequestModel>>(
                stream: ProductRepo.instance
                    .getAllRequest(context.watch<UserState>().userModel),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return getLoader();
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      snapshot.error.toString(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ));
                  }
                  if (!snapshot.hasData) {
                    return getLoader();
                  }
                  List<ProductRequestModel> declineList = snapshot.data!
                      .where((element) => !element.isApproved)
                      .where((element) => !element.ignored
                          .contains(context.watch<UserState>().userModel.uid))
                      .toList();

                  log('declineList: ${declineList.length}');

                  return declineList.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 150),
                          child: NoDataComponent(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: declineList.length,
                          itemBuilder: (context, index) {
                            log(snapshot.data?[index].toMap().toString() ??
                                "no data");
                            return FutureBuilder<UserModel>(
                                future: UserRepo.instance.getUserById(
                                    snapshot.data?[index].userId ?? ''),
                                builder: (context, snap) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container();
                                  }
                                  if (!snap.hasData) {
                                    return Container();
                                  }

                                  return WorkerRequestWidget(
                                    requestModel: declineList[index],
                                  );
                                });
                          },
                        );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
