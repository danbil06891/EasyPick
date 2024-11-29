import 'dart:developer';
import 'package:easy_pick/models/user_model.dart';
import 'package:easy_pick/view/rider/requests/widgets/rider_request_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/request_model.dart';
import '../../../repos/request_repo.dart';
import '../../../repos/user_repo.dart';
import '../../../states/user_state.dart';
import '../../../utills/snippets.dart';

class RiderRequestView extends StatefulWidget {
  const RiderRequestView({super.key});

  @override
  State<RiderRequestView> createState() => _RiderRequestViewState();
}

class _RiderRequestViewState extends State<RiderRequestView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              StreamBuilder<List<RequestModel>>(
                stream: RequestRepo.instance
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
                  List<RequestModel> requests = snapshot.data!;
                  List<RequestModel> declineList = requests
                      .where((element) => !element.ignored
                          .contains(context.watch<UserState>().userModel.uid))
                      .toList();

                  log('declineList: ${declineList.length}');

                  return declineList.isEmpty
                      ? Container()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: declineList.length,
                          itemBuilder: (context, index) {
                            log(snapshot.data?[index].toMap().toString() ??
                                "no data");
                            return FutureBuilder<UserModel>(
                                future: UserRepo.instance.getUserById(
                                    snapshot.data?[index].shopId ?? ''),
                                builder: (context, snap) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container();
                                  }
                                  if (!snap.hasData) {
                                    return Container();
                                  }
                                  return RiderRequestWidget(
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
