import 'package:easy_pick/models/product_request_model.dart';
import 'package:easy_pick/models/shop_offer_model.dart';
import 'package:easy_pick/repos/product_repo.dart';
import 'package:easy_pick/view/user/request/widgets/shop_display_offer_widget.dart';
import 'package:flutter/material.dart';

import '../../../components/no_data_component.dart';
import '../../../constants/color_constant.dart';

import '../../../utills/snippets.dart';

class UserRequestOfferList extends StatelessWidget {
  final ProductRequestModel requestModel;
  const UserRequestOfferList({super.key, required this.requestModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Offers'),
      ),
      body: StreamBuilder<List<ShopOfferModel>>(
          stream: ProductRepo.instance
              .getMyProductRequestOffers(requestModel: requestModel),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return getLoader();
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                snapshot.error.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ));
            } else if (!snapshot.hasData ||
                snapshot.data!.isEmpty ||
                snapshot.data!.any((offerModel) => offerModel.isAccepted)) {
              return const NoDataComponent();
            } else {
              return ListView.separated(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) => ShopsDisplayOffer(
                  offerModel: snapshot.data![index],
                  productRequestModel: requestModel,
                ),
              );
            }
          }),
    );
  }
}
