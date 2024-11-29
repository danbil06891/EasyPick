import 'package:flutter/material.dart';

import '../../../models/order_model.dart';
import '../../../repos/order_repo.dart';
import 'widgets/order_details_widget.dart';

class UserPickedTab extends StatefulWidget {
  const UserPickedTab({super.key});

  @override
  State<UserPickedTab> createState() => _UserPickedTabState();
}

class _UserPickedTabState extends State<UserPickedTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderRepo.instance.getUserPickedOrder(),
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
