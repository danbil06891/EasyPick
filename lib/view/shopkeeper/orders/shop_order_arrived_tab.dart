import 'package:flutter/material.dart';

import '../../../models/order_model.dart';
import '../../../repos/order_repo.dart';
import 'widgets/shop_order_detail_widget.dart';

class ShopOrderArrivedTab extends StatefulWidget {
  const ShopOrderArrivedTab({super.key});

  @override
  State<ShopOrderArrivedTab> createState() => _ShopOrderArrivedTabState();
}

class _ShopOrderArrivedTabState extends State<ShopOrderArrivedTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderRepo.instance.getShopArrivedOrder(),
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
              return ShopOrderDetailView(order: order);
            },
          );
        },
      ),
    );
  }
}
