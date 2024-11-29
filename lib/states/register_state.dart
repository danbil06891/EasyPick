import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';

class RegisterState with ChangeNotifier {
  File? selectImage;
  String? _selectedType;
  String? get selectedType => _selectedType;

  void selectImageFile(File? image) {
    if (image != null) {
      selectImage = image;
      notifyListeners();
      log(selectImage!.path);
    }else{
      selectImage = null;
      notifyListeners();
    }
  }

  void selectType(String? value) {
    _selectedType = value;
    notifyListeners();
  }
}
