import 'package:easy_pick/constants/color_constant.dart';
import 'package:easy_pick/states/map_state.dart';
import 'package:easy_pick/states/register_state.dart';
import 'package:easy_pick/view/auth/components/select_image_widget.dart';
import 'package:easy_pick/view/auth/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../repos/auth_repo.dart';
import '../../utills/snippets.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/loader_button.dart';
import 'components/rich_text.dart';
import 'components/usertypes_dropdown.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cnicController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final shopNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
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
                        prefixIcon: Icons.person,
                        controller: nameController,
                        hintText: "Name",
                        validator: mandatoryValidator,
                        labelText: 'Name',
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        maxLine: 1,
                        labelText: 'Email',
                        prefixIcon: Icons.email,
                        controller: emailController,
                        hintText: "Email",
                        validator: emailValidator,
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        maxLine: 1,
                        labelText: 'Phone No',
                        prefixIcon: Icons.phone,
                        controller: phoneController,
                        hintText: "Phone No",
                        validator: validatePhoneNumber,
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        labelText: registerState.selectedType == 'Shop Keeper'
                            ? 'Shop Address'
                            : 'Address',
                        prefixIcon: Icons.location_city,
                        controller: addressController,
                        hintText: registerState.selectedType == 'Shop Keeper'
                            ? 'Shop Address'
                            : 'Address',
                        validator: mandatoryValidator,
                        onTap: () async {
                          String? selectedAddress = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GoogleMapView()));
                          if (selectedAddress != null) {
                            addressController.text = selectedAddress;
                          }
                        },
                        readOnly: true,
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        maxLine: 1,
                        labelText: 'CNIC',
                        prefixIcon: FontAwesomeIcons.idCard,
                        controller: cnicController,
                        hintText: "XXXXX-XXXXXXX-X",
                        validator: cnicValidation,
                        inputFormatters: [
                          // Blacklist numbers
                          LengthLimitingTextInputFormatter(
                              15), // Limit to 10 characters
                        ],
                        inputType: TextInputType.number,
                        onChange: (value) {
                          setState(() {
                            cnicController.text = formatCnic(value);
                            cnicController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: cnicController.text.length));
                          });
                        },
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        maxLine: 1,
                        labelText: 'Password',
                        prefixIcon: Icons.lock,
                        isVisible: true,
                        controller: passwordController,
                        hintText: 'Password',
                        validator: passwordValidator,
                        suffixIcon: Icons.visibility,
                        suffixIcon2: Icons.visibility_off,
                      ),
                      const SizedBox(height: 22),
                      CustomTextField(
                        maxLine: 1,
                        labelText: 'Confirm Password',
                        prefixIcon: Icons.lock,
                        isVisible: true,
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        validator: confirmPasswordValidator,
                        suffixIcon: Icons.visibility,
                        suffixIcon2: Icons.visibility_off,
                      ),
                      const SizedBox(height: 22),
                      UsertypesDropdown(),
                      const SizedBox(height: 22),
                      registerState.selectedType == 'Shop Keeper'
                          ? CustomTextField(
                              maxLine: 1,
                              labelText: 'Shop Name',
                              prefixIcon: Icons.store,
                              controller: shopNameController,
                              hintText: "Shop Name",
                              validator: mandatoryValidator,
                            )
                          : Container(),
                      const SizedBox(height: 32),
                      LoaderButton(
                        btnText: 'Register',
                        radius: 30,
                        onTap: () async {
                          final mapState =
                              Provider.of<MapState>(context, listen: false);
                          try {
                            if (formKey.currentState!.validate()) {
                              if (registerState.selectedType == null) {
                                snack(context, 'Please select type',
                                    info: false);
                                return;
                              }
                              if (mapState.latLng == null) {
                                snack(context, 'Please Select Address',
                                    info: false);
                                return;
                              }
                              if (registerState.selectedType == 'Shop Keeper' &&
                                  shopNameController.text.isEmpty) {
                                snack(context, 'Please Enter Shop Name',
                                    info: false);
                                return;
                              }

                              UserModel userModel = UserModel(
                                uid: '',
                                name: nameController.text,
                                email: emailController.text,
                                phoneNo: phoneController.text,
                                address: addressController.text,
                                cnic: cnicController.text,
                                imageUrl: '',
                                type: registerState.selectedType!,
                                isApproved:
                                    registerState.selectedType == 'User',
                                isBlocked: false,
                                createdAt:
                                    DateTime.now().millisecondsSinceEpoch,
                                geoFirePoint: GeoFirePoint(
                                  mapState.latLng!.latitude,
                                  mapState.latLng!.longitude,
                                ),
                                shopName:
                                    registerState.selectedType == 'Shop Keeper'
                                        ? shopNameController.text
                                        : '',
                              );

                              await AuthRepo.instance.createUser(
                                userModel: userModel,
                                password: passwordController.text,
                                img: registerState.selectImage,
                              );
                              if (!mounted) return;
                              registerState.selectImageFile(null);
                              registerState.selectType(null);
                              mapState.setAddress(null);

                              push(context, const LoginView());
                            }
                          } catch (e) {
                            snack(context, e.toString(), info: false);
                          }
                        },
                      ),
                      const SizedBox(height: 25),
                      RichTextWidget(
                          messageText: 'Already have an account?',
                          titleText: '  Login',
                          onTap: () {
                            push(context, const LoginView());
                          })
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
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cnicController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  String? confirmPasswordValidator(String? confirmPassword) {
    if (confirmPassword != passwordController.text) {
      return 'Password do not match';
    }
    return null;
  }

  String formatCnic(String cnic) {
    String formattedCNIC = '';
    int dashCount = 0;
    for (int i = 0; i < cnic.length; i++) {
      if (cnic[i] == '-') {
        continue;
      }

      if (dashCount == 5 || dashCount == 12) {
        formattedCNIC += '-';
      }
      formattedCNIC += cnic[i];
      dashCount++;
    }

    return formattedCNIC;
  }

  String? validatePhoneNumber(String? phoneNumber) {
    // Remove any whitespace or special characters from the phone number
    phoneNumber = phoneNumber?.replaceAll(RegExp(r'\D'), '');

    // Define the regular expression pattern for a valid Pakistani phone number
    RegExp regex = RegExp(r'^(?:\+92|0)?3[0-9]{9}$');

    // Check if the phone number matches the pattern
    if (!regex.hasMatch(phoneNumber ?? '')) {
      return 'Invalid phone number format';
    }

    return null;
  }

  String? cnicValidation(String? cnic) {
    const pattern = r'^\d{5}-\d{7}-\d{1}$';

    if (cnic!.isEmpty) {
      return 'CNIC is required';
    } else if (!RegExp(pattern).hasMatch(cnic)) {
      return 'Invalid CNIC Format';
    }

    return null;
  }
}
