import 'package:easy_pick/view/user/request/widgets/user_add_request_popup.dart';
import 'package:easy_pick/view/user/request/widgets/user_request_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../repos/product_repo.dart';
import '../../../repos/user_repo.dart';
import '../../../utills/snippets.dart';
import '../../widgets/loader_button.dart';

class UserRequestView extends StatelessWidget {
  const UserRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              LoaderButton(
                btnText: 'Create Request',
                radius: 10,
                onTap: () async =>
                    showDialogOf(context, const UserAddRequestPopup()),
              ),
              StreamBuilder(
                stream: ProductRepo.instance.getProductRequestById(
                    FirebaseAuth.instance.currentUser!.uid),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return getLoader();
                  }
                  if (snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                      "No Request Found",
                      style: Theme.of(context).textTheme.titleMedium,
                    ));
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<UserModel>(
                        future: UserRepo.instance
                            .getUserById(snapshot.data![index].userId),
                        builder: (context, snap) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          }
                          if (!snap.hasData) {
                            return Container();
                          }
                          return UserRequestWidget(
                            requestModel: snapshot.data![index],
                            userModel: snap.data!,
                          );
                        },
                      );
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
