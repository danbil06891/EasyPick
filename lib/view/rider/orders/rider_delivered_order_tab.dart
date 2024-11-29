import 'dart:developer';
import 'package:easy_pick/models/order_model.dart';
import 'package:easy_pick/view/rider/orders/widgets/rider_order_details_widget.dart';
import 'package:flutter/material.dart';

import '../../../repos/order_repo.dart';

class RiderDeliveredOrderTab extends StatefulWidget {
  const RiderDeliveredOrderTab({super.key});

  @override
  State<RiderDeliveredOrderTab> createState() => _RiderDeliveredOrderTabState();
}

class _RiderDeliveredOrderTabState extends State<RiderDeliveredOrderTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderRepo.instance.getRiderCompletedOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final order = snapshot.data![index];
              log(order.toString());
              return RiderOrderDetailWidget(order: order);
            },
          );
        },
      ),
    );
  }
}
