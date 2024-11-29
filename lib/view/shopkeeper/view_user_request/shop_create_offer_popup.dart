import 'package:easy_pick/models/product_request_model.dart';
import 'package:easy_pick/utills/snippets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/shop_offer_model.dart';
import '../../../repos/product_repo.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loader_button.dart';

class ShopCreateOfferPopup extends StatefulWidget {
  final ProductRequestModel requestModel;
  const ShopCreateOfferPopup({super.key, required this.requestModel});

  @override
  State<ShopCreateOfferPopup> createState() => _ShopCreateOfferPopupState();
}

class _ShopCreateOfferPopupState extends State<ShopCreateOfferPopup> {
  final actualPriceController = TextEditingController();
  final priceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    actualPriceController.text = widget.requestModel.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 6,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              labelText: 'Actual Price',
                              readOnly: true,
                              hintText: 'Price',
                              controller: actualPriceController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              inputType: TextInputType.number,
                              maxLine: null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              labelText: 'Offer price',
                              hintText: 'Offer price',
                              controller: priceController,
                              maxLine: null,
                              inputType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        child: LoaderButton(
                          btnText: 'Send Offer',
                          onTap: () async {
                            try {
                              if (priceController.text.isEmpty) {
                                pop(context);
                                snack(context, 'Please enter offer price',
                                    info: false);

                                return;
                              }
                              ShopOfferModel offerModel = ShopOfferModel(
                                  orderId: '',
                                  docId: '',
                                  createdAt:
                                      DateTime.now().microsecondsSinceEpoch,
                                  shopId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  price: priceController.text,
                                  reqId: widget.requestModel.docId,
                                  isAccepted: false,
                                  isRejected: false);
                              await ProductRepo.instance
                                  .createOffer(widget.requestModel, offerModel);
                              if (!mounted) return;
                              pop(context);
                              snack(context, 'Offer send successfully');
                            } catch (e) {
                              snack(context, e.toString());
                              return;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
