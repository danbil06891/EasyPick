import 'package:easy_pick/models/order_model.dart';
import 'package:easy_pick/states/user_state.dart';
import 'package:easy_pick/utills/snippets.dart';
import 'package:easy_pick/view/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import '../../../models/request_model.dart';
import '../../../repos/request_repo.dart';
import '../../widgets/loader_button.dart';

class AddRequestPopup extends StatefulWidget {
  final OrderModel orderModel;
  const AddRequestPopup({super.key, required this.orderModel});

  @override
  State<AddRequestPopup> createState() => _AddRequestPopupState();
}

class _AddRequestPopupState extends State<AddRequestPopup> {
  final priceController = TextEditingController();
  final radiusController = TextEditingController();
  final descriptionController = TextEditingController();
  final itemNameController = TextEditingController();

  String? selectedType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                              labelText: 'Enter KM',
                              hintText: 'Enter KM',
                              controller: radiusController,
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
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        labelText: 'Description',
                        hintText: 'Description',
                        controller: descriptionController,
                        maxLine: null,
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 15),
                      LoaderButton(
                        btnText: 'Add Request',
                        onTap: () async {
                          RequestModel model = RequestModel(
                              orderId: widget.orderModel.orderId,
                              shopId: FirebaseAuth.instance.currentUser!.uid,
                              docId: "",
                              userId: widget.orderModel.userId,
                              price: priceController.text,
                              radius: int.parse(radiusController.text),
                              discription: descriptionController.text,
                              geoFirePoint: context
                                  .read<UserState>()
                                  .userModel
                                  .geoFirePoint,
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                              isApproved: false,
                              isDeleted: false,
                              ignored: []);
                          await RequestRepo.instance.addRequest(
                              requestModel: model,
                              orderId: widget.orderModel.orderId);
                          if (!mounted) return;
                          pop(context);
                          snack(context, 'Request added successfully');
                        },
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
