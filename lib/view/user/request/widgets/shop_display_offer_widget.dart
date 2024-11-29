import 'package:easy_pick/repos/product_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../constants/color_constant.dart';
import '../../../../enums/order_enums.dart';
import '../../../../models/order_model.dart';
import '../../../../models/product_request_model.dart';
import '../../../../models/shop_offer_model.dart';
import '../../../../models/user_model.dart';
import '../../../../repos/user_repo.dart';
import '../../../../utills/snippets.dart';
import '../../../widgets/loader_button.dart';

class ShopsDisplayOffer extends StatefulWidget {
  final ShopOfferModel offerModel;
  final ProductRequestModel productRequestModel;
  const ShopsDisplayOffer(
      {super.key, required this.offerModel, required this.productRequestModel});

  @override
  State<ShopsDisplayOffer> createState() => _ShopsDisplayOfferState();
}

class _ShopsDisplayOfferState extends State<ShopsDisplayOffer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        height: 120,
        child: FutureBuilder<UserModel>(
            future: UserRepo.instance.getUserById(widget.offerModel.shopId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return getLoader();
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ));
              } else if (!snapshot.hasData) {
                return getLoader();
              } else {
                UserModel? handyMan = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(handyMan?.imageUrl ?? ''),
                          backgroundColor: secondaryColor.withOpacity(0.7),
                          maxRadius: 20,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                handyMan?.name ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 20,
                                    color: Color.fromARGB(255, 255, 208, 0)),
                                Text(
                                  '4.5',
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Rs. ${widget.offerModel.price}',
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            // Text('Away (20 KM)',
                            //     textAlign: TextAlign.end,
                            //     style: Theme.of(context).textTheme.labelLarge),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 8),
                        // InkWell(
                        //   onTap: () =>
                        //       push(context, ChatRoom(userModel: handyMan!)),
                        //   child: const Icon(FontAwesomeIcons.message),
                        // ),
                        // const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: LoaderButton(
                              fontSize: 14,
                              btnText: 'Reject',
                              color: Colors.red,
                              onTap: () async {
                                ProductRepo.instance.rejectShopOffer(
                                    requestModel: widget.productRequestModel,
                                    offerModel: widget.offerModel);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: LoaderButton(
                              fontSize: 14,
                              btnText: 'Accept',
                              color: Colors.green,
                              onTap: () async {
                                OrderModel orderModel = OrderModel(
                                    productRequestModel:
                                        widget.productRequestModel,
                                    orderId: '',
                                    userId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    shopId: widget.offerModel.shopId,
                                    riderId: '',
                                    totalAmount: widget.offerModel.price,
                                    items: [],
                                    orderEnum: OrderEnum.pending,
                                    orderPlacedDate:
                                        DateTime.now().millisecondsSinceEpoch,
                                    orderDeliveredDate:
                                        DateTime.now().millisecondsSinceEpoch,
                                    cancelReason: '',
                                    isOrderFromRequest: true);

                                await ProductRepo.instance.acceptShopOffer(
                                    requestModel: widget.productRequestModel,
                                    offerModel: widget.offerModel);
                                await ProductRepo.instance
                                    .addProductOrder(orderModel);
                                if (!mounted) return;
                                pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }
            }),
      ),
    );
  }
}
