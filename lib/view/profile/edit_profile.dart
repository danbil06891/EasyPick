import 'dart:io';
import 'package:easy_pick/states/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../utills/snippets.dart';
import '../../components/dialog_widget.dart';
import '../../constants/color_constant.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import '../../utills/local_storage.dart';
import '../auth/login_view.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/loader_button.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);
  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  File? uploadImage;
  UserModel? userModel;
  final nameController = TextEditingController();
  final phoneNoController = TextEditingController();
  final addressController = TextEditingController();
  final cnicController = TextEditingController();
  String? imgUrl;
  @override
  void initState() {
    super.initState();
    UserRepo.instance
        .getUserById(FirebaseAuth.instance.currentUser!.uid)
        .then((e) {
      Provider.of<UserState>(context, listen: false).loadUserModelData(e);
      nameController.text = context.read<UserState>().userModel.name;
      phoneNoController.text = context.read<UserState>().userModel.phoneNo;
      addressController.text = context.read<UserState>().userModel.address;
      cnicController.text = context.read<UserState>().userModel.cnic;
      imgUrl = context.read<UserState>().userModel.imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: StreamBuilder<UserModel>(
                stream: UserRepo.instance
                    .getUserStream(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return getLoader();
                  } else {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 50),
                            Consumer<UserState>(
                                builder: (context, userProvider, child) {
                              // ignore: unnecessary_null_comparison
                              if (userProvider.userModel.uid == null) {
                                return Container();
                              } else {
                                return selectImage(
                                    imgUrl: snapshot.data!.imageUrl,
                                    userProvider: userProvider);
                              }
                            }),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      UserModel _userModel = UserModel(
                                        address: '',
                                        cnic: '',
                                        email: '',
                                        name: '',
                                        imageUrl: '',
                                        phoneNo: '',
                                        type: '',
                                        uid: '',
                                        isApproved: false,
                                        isBlocked: false,
                                        createdAt: 0,
                                        geoFirePoint: GeoFirePoint(0, 0),
                                      );
                                      Provider.of<UserState>(context,
                                              listen: false)
                                          .setUser(_userModel);
                                      Provider.of<UserState>(context,
                                              listen: false)
                                          .selectImageFile(null);
                                      FirebaseAuth.instance.signOut();
                                      LocalStorage.clear();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const LoginView()),
                                          (route) => false);
                                    },
                                    child: const Icon(
                                      FontAwesomeIcons.powerOff,
                                      color: secondaryColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        CustomTextField(
                          prefixIcon: Icons.person,
                          controller: nameController,
                          hintText: "Full Name",
                          labelText: "Full Name",
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          prefixIcon: Icons.pin,
                          controller: addressController,
                          hintText: "Address",
                          labelText: "Address",
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          prefixIcon: Icons.picture_in_picture_rounded,
                          controller: cnicController,
                          hintText: "CNIC",
                          labelText: "CNIC",
                          inputType: TextInputType.number,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          prefixIcon: Icons.phone,
                          controller: phoneNoController,
                          hintText: "Phone No",
                          labelText: "Phone No",
                          inputType: TextInputType.number,
                        ),
                        const SizedBox(height: 50),
                        LoaderButton(
                          btnText: "Update Now",
                          onTap: () async {
                            try {
                              await UserRepo.instance.updateProfile(
                                  name: nameController.text,
                                  phoneNo: phoneNoController.text,
                                  address: addressController.text,
                                  image: uploadImage,
                                  cnic: cnicController.text);
                              if (!mounted) return;
                              snack(context, 'Profile updated successfully',
                                  info: true);
                            } catch (e) {
                              snack(context, e.toString());
                            }
                          },
                        ),
                      ],
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget selectImage(
      {required String imgUrl, required UserState userProvider}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (userProvider.selectImage == null && imgUrl.isNotEmpty)
          CircleAvatar(
            radius: 58,
            backgroundImage: NetworkImage(imgUrl),
          )
        else if (userProvider.selectImage != null)
          CircleAvatar(
            backgroundImage: FileImage(userProvider.selectImage!),
            radius: 58,
          )
        else
          CircleAvatar(
            radius: 58,
            child: Text(
              userProvider.userModel.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 32),
            ),
          ),
        Positioned(
          bottom: -5,
          right: -5,
          child: SizedBox(
            height: 50,
            width: 50,
            child: Card(
              shape: getRoundShape(),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  showDialogOf(
                    context,
                    ImageDialogWidget(
                      onClick: (ref) async {
                        Navigator.of(context).pop();
                        if (ref.toString().contains("camera")) {
                          uploadImage = await pickImage(ImageSource.camera);
                        } else {
                          uploadImage = await pickImage(ImageSource.gallery);
                        }
                        // ignore: use_build_context_synchronously
                        Provider.of<UserState>(context, listen: false)
                            .selectImageFile(uploadImage!);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
