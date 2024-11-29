import 'package:easy_pick/view/rider/orders/rider_arrived_order_tab.dart';
import 'package:easy_pick/view/rider/orders/rider_assigned_order_tab.dart';
import 'package:easy_pick/view/rider/orders/rider_delivered_order_tab.dart';
import 'package:easy_pick/view/rider/orders/rider_picked_order_tab.dart';
import 'package:flutter/material.dart';

import '../../../constants/color_constant.dart';
import '../../../utills/snippets.dart';

class RiderOrderView extends StatefulWidget {
  const RiderOrderView({super.key});

  @override
  State<RiderOrderView> createState() => _RiderOrderViewState();
}

class _RiderOrderViewState extends State<RiderOrderView>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Card(
                elevation: 2,
                // margin: EdgeInsets.zero,
                shape: getRoundShape(val: 10),
                child: TabBar(
                  isScrollable: true,
                  controller: tabController,
                  labelColor: Colors.white,
                  onTap: (val) => setState(() {}),
                  indicatorColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.black,
                  indicator: BoxDecoration(
                      borderRadius: getRoundBorder(val: 4),
                      color: secondaryColor),
                  tabs: const [
                    Tab(
                        child: Text(
                      'Assigned',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                    Tab(
                        child: Text(
                      'Picked',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                    Tab(
                        child: Text(
                      'Arrived',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                    Tab(
                        child: Text(
                      'Delivered',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    RiderOrderAssignedTab(),
                    RiderPickedOrderTab(),
                    RiderArrivedOrderTab(),
                    RiderDeliveredOrderTab(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
