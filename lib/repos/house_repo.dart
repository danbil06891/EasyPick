import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/house_model.dart';

class HomeRepo {
  static final instance = HomeRepo();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String storagePath = 'houses';
  Future<void> addHouse(
      {required HouseModel model, required File image}) async {
    String id = DateTime.now().toIso8601String();
    String houseImgURL = await uploadHouseImage(
      storageReference: storage.ref().child(storagePath),
      image: image,
      name: id,
    );
    await _firestore
        .collection('houses')
        .doc(id)
        .set(model.copyWith(docId: id, houseImage: houseImgURL).toMap());
  }

  Future<String> uploadHouseImage({
    required Reference storageReference,
    required File image,
    required String name,
  }) async {
    final resp = await storageReference.child('/$name.jpg').putFile(image);
    return resp.ref.getDownloadURL();
  }

  Stream<List<HouseModel>> getAllHouse(String type) {
    return _firestore
        .collection('houses')
        .where("houseType", isEqualTo: type)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => HouseModel.fromMap(e.data())).toList(),
        );
  }

  Stream<List<HouseModel>> getAllRealEstateHouse(String id) {
    return _firestore
        .collection('houses')
        .where("uid", isEqualTo: id)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => HouseModel.fromMap(e.data())).toList(),
        );
  }
}
