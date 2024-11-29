import 'package:easy_pick/constants/color_constant.dart';
import 'package:easy_pick/models/order_model.dart';
import 'package:easy_pick/models/user_model.dart';
import 'package:easy_pick/repos/order_repo.dart';
import 'package:easy_pick/view/widgets/loader_button.dart';
import 'package:easy_pick/view/widgets/show_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../enums/order_enums.dart';
import '../../../../repos/user_repo.dart';

class OrderDetailsWidget extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsWidget({super.key, required this.order});

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
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
              future: UserRepo.instance.getUserById(widget.order.shopId),
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
                          const Icon(FontAwesomeIcons.shop, size: 16),
                          const SizedBox(width: 16),
                          Text(
                            snapshot.data?.shopName ?? " ",
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
            const SizedBox(height: 8),
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
                const SizedBox(height: 5),
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
          if (widget.order.orderEnum == OrderEnum.arrived)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoaderButton(
                borderSide: Colors.green,
                color: Colors.white,
                textColor: Colors.green,
                btnText: "Change Status To Delievered",
                onTap: () async {
                  await OrderRepo.instance.deliveredOrder(
                      orderId: widget.order.orderId,
                      orderEnum: OrderEnum.delivered);
                },
              ),
            ),
        ],
      ),
    );
  }
}
