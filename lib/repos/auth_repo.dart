import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';
import '../utills/local_storage.dart';

class AuthRepo {
  static final instance = AuthRepo();
  final firebaseAuth = FirebaseAuth.instance;
  static final FirebaseStorage storage = FirebaseStorage.instance;
  final storageReference = storage.ref().child(storagePath);
  static const String storagePath = 'profileImages';

  final firestore = FirebaseFirestore.instance;
  Future<void> createUser({
    required UserModel userModel,
    required String password,
    File? img,
    String? shopName,
  }) async {
    if (img != null) {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: userModel.email, password: password);
      String profileImg =
          await uploadImages(image: img, name: firebaseAuth.currentUser!.uid);
      await uploadUserDetails(
          userModel: userModel,
          id: firebaseAuth.currentUser!.uid,
          profileImg: profileImg);
    } else {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: userModel.email, password: password);
      await uploadUserDetails(
          userModel: userModel,
          id: firebaseAuth.currentUser!.uid,
          profileImg: '');
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserModel? userModel = await isUser(email);
      if (userModel != null) {
        if (userModel.isApproved == false) {
          return 'You are not approved by admin';
        }
        if (userModel.isBlocked == true) {
          return 'You are blocked by admin';
        }
        if (userModel.isApproved == true && userModel.isBlocked == false) {
          LocalStorage.saveString(key: 'role', value: userModel.type);
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
        }
      } else {
        log('else');
        return 'Not Found';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Invalid password.');
      }
    }
    return null;
  }

  Future<void> forgetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> uploadUserDetails(
      {required UserModel userModel,
      required String id,
      required String profileImg}) async {
    await firestore
        .collection('users')
        .doc(id)
        .set(userModel.copyWith(uid: id, imageUrl: profileImg).toMap());
  }

  Future<UserModel?> isUser(String email) async {
    QuerySnapshot<Map<String, dynamic>> documentSnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (documentSnapshot.docs.isNotEmpty) {
      return UserModel.fromMap(documentSnapshot.docs.first.data());
    } else {
      return null;
    }
  }

  Future<String> uploadImages({
    required File image,
    required String name,
  }) async {
    final resp = await storageReference.child('/$name.jpg').putFile(image);
    return resp.ref.getDownloadURL();
  }

  Future<String> isLoggedIn() async {
    return LocalStorage.getString(key: 'role');
  }

  Future<UserModel?> getUserDetail(String id) async {
    return await firestore.collection('users').doc(id).get().then((value) {
      return UserModel.fromMap(value.data()!);
    });
  }
}
