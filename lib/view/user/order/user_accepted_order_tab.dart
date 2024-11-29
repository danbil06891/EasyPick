import 'package:easy_pick/view/user/order/widgets/order_details_widget.dart';
import 'package:flutter/material.dart';
import '../../../models/order_model.dart';
import '../../../repos/order_repo.dart';

class UserAcceptedOrderTab extends StatefulWidget {
  const UserAcceptedOrderTab({super.key});

  @override
  State<UserAcceptedOrderTab> createState() => _UserAcceptedOrderTabState();
}

class _UserAcceptedOrderTabState extends State<UserAcceptedOrderTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderRepo.instance.getUserAcceptedOrders(),
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
