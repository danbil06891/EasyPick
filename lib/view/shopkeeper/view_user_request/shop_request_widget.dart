import 'dart:developer';

import 'package:easy_pick/models/product_request_model.dart';
import 'package:easy_pick/models/shop_offer_model.dart';
import 'package:easy_pick/repos/product_repo.dart';
import 'package:easy_pick/view/shopkeeper/view_user_request/shop_create_offer_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/color_constant.dart';

import '../../../utills/snippets.dart';
import '../../widgets/show_status_widget.dart';

class WorkerRequestWidget extends StatefulWidget {
  final ProductRequestModel requestModel;
  const WorkerRequestWidget({super.key, required this.requestModel});

  @override
  State<WorkerRequestWidget> createState() => _WorkerRequestWidgetState();
}

class _WorkerRequestWidgetState extends State<WorkerRequestWidget> {
  @override
  Widget build(BuildContext context) {
    log('WorkerRequestWidget build');
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.abc, color: Colors.grey),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    widget.requestModel.discription,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const Divider(color: greyColor, indent: 28),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 15),
                  Row(
                    children: [
                      Text(
                        'Product: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.requestModel.selectedCategory}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Sub-Category: ',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.requestModel.selectedSubCategory}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
            const Divider(color: greyColor, height: 15, indent: 28),
            StreamBuilder<ShopOfferModel?>(
              stream: ProductRepo.instance
                  .checkIfOfferExist(requestModel: widget.requestModel),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }

                if (snapshot.hasData && snapshot.data != null) {
                  final ShopOfferModel offerModel = snapshot.data!;
                  if (offerModel.isAccepted == true) {
                    return const Align(
                      alignment: Alignment.centerRight,
                      child: ShowStatusWidget(
                          color: Colors.green, text: 'Accepted'),
                    );
                  } else if (offerModel.isRejected == true) {
                    return const Align(
                      alignment: Alignment.centerRight,
                      child:
                          ShowStatusWidget(color: Colors.red, text: 'Rejected'),
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
                      ActionButton(
                        borderColor: Colors.red,
                        buttonColor: Colors.white,
                        text: 'Decline',
                        textColor: Colors.red,
                        onPressed: () async {
                          await ProductRepo.instance.declineRequest(
                              model: widget.requestModel,
                              shopId: FirebaseAuth.instance.currentUser!.uid);
                        },
                      ),
                      ActionButton(
                        borderColor: Colors.green,
                        buttonColor: Colors.white,
                        text: 'Accept',
                        textColor: Colors.green,
                        onPressed: () async {
                          try {
                            ShopOfferModel offerModel = ShopOfferModel(
                                orderId: '',
                                docId: '',
                                createdAt:
                                    DateTime.now().microsecondsSinceEpoch,
                                shopId: FirebaseAuth.instance.currentUser!.uid,
                                price: widget.requestModel.price,
                                reqId: widget.requestModel.docId,
                                isAccepted: false,
                                isRejected: false);
                            await ProductRepo.instance
                                .createOffer(widget.requestModel, offerModel)
                                .then((value) => snack(context, 'Offer sent'));
                          } catch (e) {
                            snack(context, e.toString());
                            return;
                          }
                        },
                      ),
                      ActionButton(
                        borderColor: Colors.green,
                        buttonColor: Colors.green,
                        text: 'Create Offer',
                        textColor: Colors.white,
                        onPressed: () async {
                          showDialogOf(
                              context,
                              ShopCreateOfferPopup(
                                requestModel: widget.requestModel,
                              ));
                        },
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

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;

  const ActionButton({
    required this.onPressed,
    required this.text,
    required this.buttonColor,
    required this.textColor,
    required this.borderColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: borderColor),
        ),
        foregroundColor: Colors.white,
        backgroundColor: buttonColor,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style:
            Theme.of(context).textTheme.titleSmall?.copyWith(color: textColor),
      ),
    );
  }
}
