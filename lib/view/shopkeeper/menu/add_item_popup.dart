import 'dart:developer';

import 'package:easy_pick/constants/color_constant.dart';
import 'package:easy_pick/states/register_state.dart';
import 'package:easy_pick/utills/snippets.dart';
import 'package:easy_pick/view/auth/components/select_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import '../../../models/item_model.dart';
import '../../../repos/item_repo.dart';
import '../../../states/user_state.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loader_button.dart';

class AddItemPopup extends StatefulWidget {
  const AddItemPopup({super.key});

  @override
  State<AddItemPopup> createState() => _AddItemPopupState();
}

class _AddItemPopupState extends State<AddItemPopup> {
  String? selectedCategory;
  final itemNameController = TextEditingController();
  final itemPriceController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<String> defaultCategory = [
    'Biscuits',
    'Cooking Oil',
    'Milk Pack',
    'Shamposs',
    'Soaps',
  ];
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Add Item',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Consumer<RegisterState>(builder: (context, registerState, value) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const SelectImageWidget(),
                      const SizedBox(height: 20),
                      CustomTextField(
                        maxLine: 1,
                        prefixIcon: Icons.abc,
                        controller: itemNameController,
                        hintText: "Name",
                        validator: mandatoryValidator,
                        labelText: 'Name',
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        maxLine: 1,
                        labelText: 'Price',
                        prefixIcon: Icons.price_check,
                        controller: itemPriceController,
                        hintText: "Price",
                        validator: mandatoryValidator,
                        inputType: TextInputType.number,
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        maxLine: 1,
                        labelText: 'Description',
                        prefixIcon: Icons.abc,
                        controller: descriptionController,
                        hintText: "Description",
                        validator: mandatoryValidator,
                      ),
                      const SizedBox(height: 22),
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
                          dropdownColor: textFieldColor,
                          iconEnabledColor: primaryColor,
                          isExpanded: true,
                          value: selectedCategory,
                          items: defaultCategory.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(value),
                              ),
                              onTap: () {},
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value.toString();
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      LoaderButton(
                        btnText: 'Add Item',
                        radius: 30,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            if (registerState.selectImage == null) {
                              snack(context, 'Please select image',
                                  info: false);
                              return;
                            }
                            if (selectedCategory == null) {
                              snack(context, 'Please select select category',
                                  info: false);
                              return;
                            }
                            log(registerState.selectImage.toString());
                            ItemModel model = ItemModel(
                                itemId: "",
                                authId: context.read<UserState>().userModel.uid,
                                name: itemNameController.text,
                                description: descriptionController.text,
                                price: itemPriceController.text,
                                image: "",
                                category: selectedCategory!,
                                isDeleted: false,
                                createdAt:
                                    DateTime.now().millisecondsSinceEpoch);

                            await ItemRepo.instance.addItem(
                              img: registerState.selectImage!,
                              model: model,
                            );
                            if (!mounted) return;
                            registerState.selectImageFile(null);
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const SizedBox(height: 25),
                    ]),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    itemNameController.dispose();
    itemPriceController.dispose();
    descriptionController.dispose();
  }
}
