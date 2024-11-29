import 'dart:developer';
import 'package:easy_pick/models/order_model.dart';
import 'package:easy_pick/repos/order_repo.dart';
import 'package:flutter/material.dart';
import 'widgets/order_details_widget.dart';

class UserArrivedOrderTab extends StatefulWidget {
  const UserArrivedOrderTab({Key? key}) : super(key: key);

  @override
  State<UserArrivedOrderTab> createState() => _UserArrivedOrderTabState();
}

class _UserArrivedOrderTabState extends State<UserArrivedOrderTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OrderRepo.instance.getRiderArrivedOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<OrderModel>>(
        stream: OrderRepo.instance.getUserArrivedOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final order = snapshot.data![index];
              log(order.toString());
              return OrderDetailsWidget(order: order);
            },
          );
        },
      ),
    );
  }
}
