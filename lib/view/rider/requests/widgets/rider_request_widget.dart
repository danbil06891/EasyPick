import 'dart:developer';
import 'package:easy_pick/models/offer_model.dart';
import 'package:easy_pick/utills/snippets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../constants/color_constant.dart';
import '../../../../models/request_model.dart';
import '../../../../models/user_model.dart';
import '../../../../repos/offer_repo.dart';
import '../../../../repos/request_repo.dart';
import '../../../../repos/user_repo.dart';
import '../../../widgets/loader_button.dart';
import '../../../widgets/show_status_widget.dart';
import '../offers/create_offer_popup.dart';

class RiderRequestWidget extends StatefulWidget {
  final RequestModel requestModel;
  const RiderRequestWidget({super.key, required this.requestModel});

  @override
  State<RiderRequestWidget> createState() => _RiderRequestWidgetState();
}

class _RiderRequestWidgetState extends State<RiderRequestWidget> {
  UserModel? userModel;
  UserModel? shopModel;
  @override
  void initState() {
    super.initState();
    getUserShopInfo(
        shopId: widget.requestModel.shopId, userId: widget.requestModel.userId);
  }

  Future<void> getUserShopInfo(
      {required String userId, required String shopId}) async {
    try {
      log("getUserShopInfo ID: $userId, $shopId");

      final userFuture = UserRepo.instance.getUserById(userId);

      final shopFuture = UserRepo.instance.getUserById(shopId);

      List<UserModel> results = await Future.wait([userFuture, shopFuture]);

      userModel = results[0];
      shopModel = results[0];
      setState(() {});
    } catch (e) {
      print('getUserShopInfo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return userModel == null
        ? Container()
        : Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Pick From',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      )),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(FontAwesomeIcons.shop,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          shopModel?.shopName ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(FontAwesomeIcons.locationDot,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          shopModel?.address ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Deliver To',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w700),
                      )),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(FontAwesomeIcons.house,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          userModel?.name ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(FontAwesomeIcons.locationDot,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          userModel?.address ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: greyColor, indent: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 15),
                      Row(
                        children: [
                          Text(
                            'Price: ',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.requestModel.price} Rs.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Radius: ',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.requestModel.radius} KM',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Date: ',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            parseDate(DateTime.fromMillisecondsSinceEpoch(
                                widget.requestModel.createdAt)),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: greyColor, indent: 28),
                  StreamBuilder<OfferModel?>(
                    stream: OfferRepo.instance
                        .checkIfOfferExist(requestModel: widget.requestModel),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        final OfferModel offerModel = snapshot.data!;
                        if (offerModel.isAccepted == true) {
                          return const Align(
                            alignment: Alignment.centerRight,
                            child: ShowStatusWidget(
                                color: Colors.green, text: 'Accepted'),
                          );
                        } else if (offerModel.isRejected == true) {
                          return const Align(
                            alignment: Alignment.centerRight,
                            child: ShowStatusWidget(
                                color: Colors.red, text: 'Rejected'),
                          );
                        } else {
                          return const Align(
                            alignment: Alignment.centerRight,
                            child: ShowStatusWidget(
                                color: Colors.orange, text: 'Pending'),
                          );
                        }
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 89,
                              height: 30,
                              child: LoaderButton(
                                btnText: 'Decline',
                                fontSize: 13,
                                borderSide: Colors.red,
                                onTap: () async {
                                  await RequestRepo.instance.declineRequest(
                                      model: widget.requestModel,
                                      riderId: FirebaseAuth
                                          .instance.currentUser!.uid);
                                  if (!mounted) return;
                                  snack(
                                      context, 'Request decline successfully');
                                },
                                color: Colors.white,
                                textColor: Colors.red,
                              ),
                            ),
                            SizedBox(
                              width: 89,
                              height: 30,
                              child: LoaderButton(
                                btnText: 'Accept',
                                fontSize: 13,
                                borderSide: Colors.green,
                                onTap: () async {
                                  OfferModel model = OfferModel(
                                      reqId: widget.requestModel.docId,
                                      docId: "",
                                      orderId: widget.requestModel.orderId,
                                      price: widget.requestModel.price,
                                      riderId: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      isAccepted: false,
                                      isRejected: false,
                                      createdAt: DateTime.now()
                                          .millisecondsSinceEpoch);
                                  await OfferRepo.instance.acceptUserOffer(
                                      widget.requestModel, model);
                                  if (!mounted) return;
                                  snack(
                                      context, 'Request accepted successfully');
                                },
                                color: Colors.white,
                                textColor: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: 124,
                              height: 30,
                              child: LoaderButton(
                                btnText: 'Create Offer',
                                fontSize: 13,
                                onTap: () async {
                                  showDialogOf(
                                      context,
                                      CreateOfferPopup(
                                        requestModel: widget.requestModel,
                                      ));
                                },
                                color: Colors.green,
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
