import 'package:easy_pick/view/user/order/widgets/order_details_widget.dart';
import 'package:flutter/material.dart';

import '../../../models/order_model.dart';
import '../../../repos/order_repo.dart';

class ShopOrderPickedTab extends StatefulWidget {
  const ShopOrderPickedTab({super.key});

  @override
  State<ShopOrderPickedTab> createState() => _ShopOrderPickedTabState();
}

class _ShopOrderPickedTabState extends State<ShopOrderPickedTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderRepo.instance.getShopPickedOrder(),
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
              return OrderDetailsWidget(order: order);
            },
          );
        },
      ),
    );
  }
}
