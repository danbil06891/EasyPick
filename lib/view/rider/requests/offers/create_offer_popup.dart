import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import '../../../../models/offer_model.dart';
import '../../../../models/request_model.dart';
import '../../../../repos/offer_repo.dart';
import '../../../../states/user_state.dart';
import '../../../../utills/snippets.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/loader_button.dart';

class CreateOfferPopup extends StatefulWidget {
  final RequestModel requestModel;
  const CreateOfferPopup({super.key, required this.requestModel});

  @override
  State<CreateOfferPopup> createState() => _CreateOfferPopupState();
}

class _CreateOfferPopupState extends State<CreateOfferPopup> {
  final actualPriceController = TextEditingController();
  final priceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    actualPriceController.text = widget.requestModel.price.toString();

    priceController.text = '100';
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
                              OfferModel offerModel = OfferModel(
                                  orderId: widget.requestModel.orderId,
                                  docId: '',
                                  createdAt:
                                      DateTime.now().microsecondsSinceEpoch,
                                  riderId:
                                      context.read<UserState>().userModel.uid,
                                  price: priceController.text,
                                  reqId: widget.requestModel.docId,
                                  isAccepted: false,
                                  isRejected: false);
                              await OfferRepo.instance
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
