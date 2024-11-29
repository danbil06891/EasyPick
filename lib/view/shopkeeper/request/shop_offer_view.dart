import 'package:easy_pick/constants/color_constant.dart';
import 'package:easy_pick/models/offer_model.dart';
import 'package:easy_pick/models/order_model.dart';
import 'package:easy_pick/models/request_model.dart';
import 'package:easy_pick/repos/offer_repo.dart';
import 'package:flutter/material.dart';

import '../../../components/no_data_component.dart';
import '../../../utills/snippets.dart';
import 'widget/display_offer_widget.dart';

class ShopOffersListView extends StatelessWidget {
  final RequestModel requestModel;
  final OrderModel orderModel;
  const ShopOffersListView(
      {super.key, required this.requestModel, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Offers'),
      ),
      body: StreamBuilder<List<OfferModel>>(
          stream: OfferRepo.instance.getMyOffers(requestModel: requestModel),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return getLoader();
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                snapshot.error.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ));
            } else if (!snapshot.hasData) {
              return Center(
                  child: Text(
                'No Data Found',
                style: Theme.of(context).textTheme.titleMedium,
              ));
            } else if (snapshot.data!.isEmpty) {
              return const NoDataComponent();
            } else {
              return ListView.separated(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) => DisplayOffers(
                  offerModel: snapshot.data![index],
                  requestModel: requestModel,
                  orderModel: orderModel,
                ),
              );
            }
          }),
    );
  }
}
