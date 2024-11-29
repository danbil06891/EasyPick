import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';

class UserRepo {
  static final instance = UserRepo();
  final _userCollection = FirebaseFirestore.instance.collection('users');
  final firestore = FirebaseFirestore.instance;
  final Reference _profiles = FirebaseStorage.instance.ref().child('profiles');
  Future<String> _uploadImage(
      {required String name,
      required File image,
      required Reference reference}) async {
    final resp = await reference.child('$name.png').putFile(image);
    return resp.ref.getDownloadURL();
  }

  Future<UserModel?> getUserDetail(String id) async {
    return await firestore
        .collection('users')
        .doc(id)
        .get()
        .then((value) => UserModel.fromMap(value.data()!));
  }

  Stream<UserModel> getUserStream(String id) {
    return firestore
        .collection('users')
        .doc(id)
        .snapshots()
        .map((value) => UserModel.fromMap(value.data()!));
  }

  Stream<List<UserModel>> getAllUserByType(String type) {
    return firestore
        .collection('users')
        .where("type", isEqualTo: type)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => UserModel.fromMap(e.data())).toList(),
        );
  }

  Future<UserModel> getUserById(String id) async {
    return _userCollection
        .doc(id)
        .get()
        .then((value) => UserModel.fromMap(value.data() as dynamic));
  }

  Future<String?> updateProfile(
      {required String name,
      required String address,
      required String phoneNo,
      required String cnic,
      File? image}) async {
    String? url;
    if (image != null) {
      url = await _uploadImage(
        reference: _profiles,
        image: image,
        name: FirebaseAuth.instance.currentUser!.uid,
      );
      await _userCollection.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'name': name,
        'address': address,
        'phoneNo': phoneNo,
        'imageUrl': url,
        'cnic': cnic
      });

      return url;
    } else {
      await _userCollection.doc(FirebaseAuth.instance.currentUser!.uid).update(
          {'name': name, 'address': address, 'phoneNo': phoneNo, 'cnic': cnic});
      return url;
    }
  }
}
