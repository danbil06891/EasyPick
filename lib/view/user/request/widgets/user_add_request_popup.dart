import 'package:easy_pick/constants/color_constant.dart';
import 'package:easy_pick/models/product_request_model.dart';
import 'package:easy_pick/repos/product_repo.dart';
import 'package:easy_pick/states/user_state.dart';
import 'package:easy_pick/view/widgets/loader_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:provider/provider.dart';

import '../../../../utills/snippets.dart';
import '../../../widgets/custom_textfield.dart';

class UserAddRequestPopup extends StatefulWidget {
  const UserAddRequestPopup({super.key});

  @override
  State<UserAddRequestPopup> createState() => _UserAddRequestPopupState();
}

class _UserAddRequestPopupState extends State<UserAddRequestPopup> {
  String? selectedCategory;
  String? selectedSubCategory;
  final priceController = TextEditingController();
  final radiusController = TextEditingController();
  final descriptionController = TextEditingController();

  Map<String, dynamic> categories = {
    "Biscuits": ["Tuc", "Oreo", "Super", "Prime"],
    "Cooking Oil": ["Dalda", "Sufi", "Soya Supreme", "Sundrop"],
    "Milk Pack": [
      "Milk Pack",
      "Milk Pack Cream",
      "Milk Pack Butter",
      "Milk Pack Cheese"
    ],
    "Shamposs": ["Life Boy", "Panteen", "Clear", "Dove", "Sunsilk", "Pamolive"],
    "Soaps": ["Lux", "Detol", "Safe Guard", "Dove", "Life Boy"]
  };

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
                      Container(
                        height: 50,
                        padding: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: textFieldColor,
                        ),
                        child: DropdownButtonFormField(
                          elevation: 4,
                          autofocus: false,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: 13, bottom: 0),
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              FontAwesomeIcons.typo3,
                              color: greyColor,
                              size: 15,
                            ),
                          ),
                          hint: Text(
                            'Select Category',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.grey),
                          ),
                          style: Theme.of(context).textTheme.titleSmall,
                          // dropdownColor: textFieldColor,
                          iconEnabledColor: secondaryColor,
                          isExpanded: true,
                          value: selectedCategory,
                          items: categories.keys.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                              onTap: () {},
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value.toString();
                              selectedSubCategory = null;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      selectedCategory == null
                          ? const SizedBox.shrink()
                          : Container(
                              height: 50,
                              padding: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: textFieldColor,
                              ),
                              child: DropdownButtonFormField(
                                elevation: 4,
                                autofocus: false,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(top: 13, bottom: 0),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    FontAwesomeIcons.typo3,
                                    color: greyColor,
                                    size: 15,
                                  ),
                                ),
                                hint: Text(
                                  'Sub Category',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: Colors.grey),
                                ),
                                style: Theme.of(context).textTheme.titleSmall,
                                // dropdownColor: textFieldColor,
                                iconEnabledColor: secondaryColor,
                                isExpanded: true,
                                value: selectedSubCategory,
                                items: selectedCategory != null
                                    ? categories[selectedCategory]
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()
                                    : null,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSubCategory = value.toString();
                                  });
                                },
                              ),
                            ),
                      selectedCategory == null
                          ? const SizedBox.shrink()
                          : const SizedBox(height: 15),
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
                      LoaderButton(
                        btnText: 'Add Request',
                        onTap: () async {
                          final userState =
                              Provider.of<UserState>(context, listen: false);

                          if (selectedCategory == null) {
                            snack(context, 'Please select a category',
                                info: false);
                            return;
                          }

                          if (selectedSubCategory == null) {
                            snack(context, 'Please select sub category',
                                info: false);
                            return;
                          }
                          ProductRequestModel productRequestModel =
                              ProductRequestModel(
                            docId: '',
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            shopId: '',
                            price: priceController.text,
                            radius: int.parse(radiusController.text),
                            ignored: [],
                            selectedCategory: selectedCategory!,
                            selectedSubCategory: selectedSubCategory!,
                            isDeleted: false,
                            isApproved: false,
                            geoFirePoint: GeoFirePoint(
                              userState.userModel.geoFirePoint.latitude,
                              userState.userModel.geoFirePoint.latitude,
                            ),
                            discription: descriptionController.text,
                            createdAt: DateTime.now().millisecondsSinceEpoch,
                          );
                          await ProductRepo.instance
                              .addProductRequest(productRequestModel);
                          if (!mounted) return;
                          pop(context);
                          snack(context, 'Add Request Successfully');
                          descriptionController.clear();
                          setState(() {
                            selectedCategory = null;
                            selectedSubCategory = null;
                          });
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
