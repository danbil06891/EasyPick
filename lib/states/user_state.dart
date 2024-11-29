import 'dart:developer';
import 'dart:io';

import 'package:easy_pick/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class UserState extends ChangeNotifier {
  File? selectImage;
  String? _selectedType;
  String? get selectedType => _selectedType;

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

  UserModel get userModel => _userModel;

  void setUser(UserModel user) {
    _userModel = user;
    log('User Provider: ${_userModel.type}');
    notifyListeners();
  }

  loadUserModelData(UserModel model) {
    _userModel = model;
    notifyListeners();
  }

  void selectImageFile(File? image) {
    if (image != null) {
      selectImage = image;
      notifyListeners();
      log(selectImage!.path);
    } else {
      selectImage = null;
      notifyListeners();
    }
  }

  void selectType(String value) {
    _selectedType = value;
    notifyListeners();
  }
}
