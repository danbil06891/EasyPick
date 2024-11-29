import 'package:easy_pick/constants/color_constant.dart';
import 'package:easy_pick/enums/order_enums.dart';
import 'package:easy_pick/models/order_model.dart';
import 'package:easy_pick/models/request_model.dart';
import 'package:easy_pick/models/user_model.dart';
import 'package:easy_pick/repos/order_repo.dart';
import 'package:easy_pick/repos/request_repo.dart';
import 'package:easy_pick/utills/snippets.dart';
import 'package:easy_pick/view/shopkeeper/request/shop_offer_view.dart';
import 'package:easy_pick/view/widgets/loader_button.dart';
import 'package:easy_pick/view/widgets/show_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../repos/user_repo.dart';
import '../../request/add_request_popup.dart';

class ShopOrderDetailView extends StatefulWidget {
  final OrderModel order;

  const ShopOrderDetailView({super.key, required this.order});

  @override
  State<ShopOrderDetailView> createState() => _ShopOrderDetailViewState();
}

class _ShopOrderDetailViewState extends State<ShopOrderDetailView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(FontAwesomeIcons.hashtag, size: 16),
                const SizedBox(width: 16),
                Text(
                  widget.order.orderId,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<UserModel>(
              future: UserRepo.instance.getUserById(widget.order.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(height: 20);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.user, size: 16),
                          const SizedBox(width: 16),
                          Text(
                            snapshot.data?.name ?? " ",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.locationDot, size: 16),
                          const SizedBox(width: 16),
                          Flexible(
                            child: Text(
                              'Address: ${snapshot.data?.address ?? " "}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Align(
                alignment: Alignment.centerRight,
                child: ShowStatusWidget(
                    color: widget.order.orderEnum.getColor(),
                    text: widget.order.orderEnum.getName())),
          ),
          const SizedBox(height: 8),
          if (widget.order.riderId.isNotEmpty)
            FutureBuilder<UserModel>(
                future: UserRepo.instance.getUserById(widget.order.riderId),
                builder: (_, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 10);
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(snap.data?.imageUrl ?? ''),
                          radius: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Rider: ${snap.data?.name ?? ''}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          widget.order.riderId.isNotEmpty
              ? const SizedBox(height: 16)
              : const SizedBox.shrink(),
          if (widget.order.isOrderFromRequest == false)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Items:',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          if (widget.order.isOrderFromRequest == false)
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.order.items?.length,
              itemBuilder: (context, index) {
                final item = widget.order.items![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 21,
                        backgroundImage: NetworkImage(
                          item.image,
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      // subtitle: Text(item.description),
                      trailing: Text('${item.quantity}x ${item.price}'),
                    ),
                  ),
                );
              },
            ),
          if (widget.order.isOrderFromRequest == true)
            if (widget.order.isOrderFromRequest == true)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      widget.order.productRequestModel?.selectedCategory ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                        widget.order.productRequestModel?.selectedSubCategory ??
                            ''),
                    // trailing: Text('${item.quantity}x ${item.price}'),
                  ),
                ),
              ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Payable Amount:',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${widget.order.totalAmount} Rs',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Date:',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.order.formattedOrderPlacedDate,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                widget.order.orderEnum.index == OrderEnum.delivered.index
                    ? const SizedBox(height: 5)
                    : const SizedBox.shrink(),
                widget.order.orderEnum.index == OrderEnum.delivered.index
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivered At:',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            widget.order.formattedOrderDeliveredDate,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          if (widget.order.orderEnum == OrderEnum.pending)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LoaderButton(
                          borderSide: Colors.red,
                          color: Colors.white,
                          textColor: Colors.red,
                          btnText: "Reject",
                          onTap: () async {
                            await OrderRepo.instance.rejectOrder(
                                orderId: widget.order.orderId,
                                orderEnum: OrderEnum.rejected);
                          },
                        )),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LoaderButton(
                            color: Colors.green,
                            btnText: "Accept",
                            onTap: () async {
                              await OrderRepo.instance.acceptOrder(
                                orderId: widget.order.orderId,
                                orderEnum: OrderEnum.accepted,
                              );
                            })),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          if (widget.order.orderEnum == OrderEnum.accepted)
            StreamBuilder<RequestModel?>(
                stream: RequestRepo.instance
                    .checkIfOrderRequestExist(orderId: widget.order.orderId),
                builder: (_, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final RequestModel requestModel = snapshot.data!;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LoaderButton(
                              color: Colors.green,
                              btnText: "View Your Request Offers",
                              onTap: () async {
                                push(
                                    context,
                                    ShopOffersListView(
                                      orderModel: widget.order,
                                      requestModel: requestModel,
                                    ));
                              }),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: LoaderButton(
                              color: Colors.green,
                              btnText: "Send Request To Riders ",
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (_) => AddRequestPopup(
                                          orderModel: widget.order,
                                        ));
                              }),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                }),
        ],
      ),
    );
  }
}
