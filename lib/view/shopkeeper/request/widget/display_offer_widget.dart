import 'package:easy_pick/constants/color_constant.dart';
import 'package:easy_pick/models/offer_model.dart';
import 'package:easy_pick/models/order_model.dart';
import 'package:easy_pick/models/user_model.dart';
import 'package:easy_pick/repos/offer_repo.dart';
import 'package:easy_pick/repos/order_repo.dart';
import 'package:easy_pick/utills/snippets.dart';
import 'package:flutter/material.dart';

import '../../../../enums/order_enums.dart';
import '../../../../models/request_model.dart';
import '../../../../repos/user_repo.dart';
import '../../../widgets/loader_button.dart';

class DisplayOffers extends StatefulWidget {
  final OfferModel offerModel;
  final RequestModel requestModel;
  final OrderModel orderModel;
  const DisplayOffers(
      {super.key,
      required this.offerModel,
      required this.requestModel,
      required this.orderModel});

  @override
  State<DisplayOffers> createState() => _DisplayOffersState();
}

class _DisplayOffersState extends State<DisplayOffers> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        height: 120,
        child: FutureBuilder<UserModel>(
            future: UserRepo.instance.getUserById(widget.offerModel.riderId),
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
                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: 35,
                            child: LoaderButton(
                              fontSize: 14,
                              btnText: 'Reject',
                              color: Colors.red,
                              onTap: () async {
                                await OfferRepo.instance.rejectOffer(
                                  requestModel: widget.requestModel,
                                  offerModel: widget.offerModel,
                                );
                                if (!mounted) return;
                                snack(context, 'Offer Rejected');
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
                                await OfferRepo.instance.acceptRiderOffer(
                                    requestModel: widget.requestModel,
                                    offerModel: widget.offerModel);

                                await OrderRepo.instance.assignOrderToRider(
                                    orderEnum: OrderEnum.assigned,
                                    orderId: widget.orderModel.orderId,
                                    riderId: widget.offerModel.riderId);
                                if (!mounted) return;
                                pop(context);
                                snack(context, 'Rider Assigned');
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
