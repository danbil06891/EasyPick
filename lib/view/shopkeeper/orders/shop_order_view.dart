import 'package:easy_pick/view/shopkeeper/orders/shop_order_arrived_tab.dart';
import 'package:easy_pick/view/shopkeeper/orders/shop_order_assigned_tab.dart';
import 'package:easy_pick/view/shopkeeper/orders/shop_order_delivered_tab.dart';
import 'package:easy_pick/view/shopkeeper/orders/shop_order_pending_tab.dart';
import 'package:easy_pick/view/shopkeeper/orders/show_order_accepted_tab.dart';
import 'package:flutter/material.dart';

import '../../../constants/color_constant.dart';
import '../../../utills/snippets.dart';
import 'shop_order_picked_tab.dart';

class ShopHomeview extends StatefulWidget {
  const ShopHomeview({super.key});

  @override
  State<ShopHomeview> createState() => _ShopHomeviewState();
}

class _ShopHomeviewState extends State<ShopHomeview>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this, initialIndex: 0);
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
                      'Pending',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                    Tab(
                        child: Text(
                      'Accepted',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                    Tab(
                        child: Text(
                      'Assigned',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                    Tab(
                      child: Text(
                        'Picked',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Arrived',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Delivered',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    ShopOrderPendingTab(),
                    ShowOrderAcceptedTab(),
                    AssignedOrderTabView(),
                    ShopOrderPickedTab(),
                    ShopOrderArrivedTab(),
                    ShopOrderDeliveredTab(),
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
