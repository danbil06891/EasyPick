import 'dart:developer';
import 'dart:math' show atan2, cos, pi, pow, sin, sqrt;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pick/models/offer_model.dart';
import 'package:easy_pick/models/order_model.dart';
import 'package:easy_pick/models/product_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/shop_offer_model.dart';
import '../models/user_model.dart';

class ProductRepo {
  static final instance = ProductRepo();
  final firestore = FirebaseFirestore.instance;

  Future<void> addProductOrder(OrderModel model) async {
    String docId = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(docId)
        .set(model.copyWith(orderId: docId).toMap());
  }

  Stream<ShopOfferModel?> checkIfOfferExist(
      {required ProductRequestModel requestModel}) {
    return firestore
        .collection('productRequest')
        .doc(requestModel.docId)
        .collection('offers')
        .where('shopId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return ShopOfferModel.fromMap(data);
      } else {
        return null;
      }
    });
  }

  Future<void> addProductRequest(
      ProductRequestModel productRequestModel) async {
    String docId = DateTime.now().toIso8601String();
    await firestore
        .collection('productRequest')
        .doc(docId)
        .set(productRequestModel.copyWith(docId: docId).toMap());
  }

  Stream<List<ProductRequestModel>> getProductRequestById(String uid) {
    return firestore
        .collection('productRequest')
        .where('userId', isEqualTo: uid)
        .where('isApproved', isEqualTo: false)
        .snapshots()
        .map((event) => event.docs
            .map((e) => ProductRequestModel.fromMap(e.data()))
            .toList());
  }

  Stream<List<ProductRequestModel>> getAllRequest(UserModel userModel) {
    final centerLatLng = LatLng(
        userModel.geoFirePoint.latitude, userModel.geoFirePoint.longitude);

    return firestore
        .collection('productRequest')
        .where('isApproved', isEqualTo: false)
        .snapshots()
        .distinct()
        .map((event) => event.docs
                .map((e) => ProductRequestModel.fromMap(e.data()))
                .where((request) {
              LatLng requestLatLng = LatLng(request.geoFirePoint.latitude,
                  request.geoFirePoint.longitude);

              final radius = request.radius * 1000;
              final distance = calculateDistance(centerLatLng, requestLatLng);
              return distance <= radius;
            }).toList());
  }

  Future<void> acceptUserOffer(ProductRequestModel productRequestModel,
      ShopOfferModel offerModel) async {
    String docId = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore
        .collection('productRequest')
        .doc(productRequestModel.docId)
        .collection('offers')
        .doc(docId)
        .set(offerModel.copyWith(docId: docId).toMap());
  }

  Future<void> createOffer(
      ProductRequestModel requestModel, ShopOfferModel offerModel) async {
    String docId = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore
        .collection('productRequest')
        .doc(requestModel.docId)
        .collection('offers')
        .doc(docId)
        .set(offerModel.copyWith(docId: docId).toMap());
  }

  Future<void> rejectOffer(
      {required ProductRequestModel requestModel,
      required OfferModel offerModel}) async {
    List<String> ignoredlist = requestModel.ignored;
    ignoredlist.add(FirebaseAuth.instance.currentUser!.uid);
    await firestore
        .collection('productRequest')
        .doc(requestModel.docId)
        .collection('offers')
        .doc(offerModel.docId)
        .update({
      'isRejected': true,
    });
  }

  // Future<void> acceptUserOffer(
  //     {required ProductRequestModel requestModel,
  //     required ShopOfferModel offerModel}) async {
  //   await firestore
  //       .collection('requests')
  //       .doc(requestModel.docId)
  //       .update({'isAccepted': true, 'shopId': offerModel.shopId});
  //   await firestore
  //       .collection('requests')
  //       .doc(requestModel.docId)
  //       .collection('offers')
  //       .doc(offerModel.docId)
  //       .update({'isAccepted': true});
  // }

  Stream<List<ShopOfferModel>> getMyProductRequestOffers(
      {required ProductRequestModel requestModel}) {
    return firestore
        .collection('productRequest')
        .doc(requestModel.docId)
        .collection('offers')
        .where('isAccepted', isEqualTo: false)
        .where('isRejected', isEqualTo: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => ShopOfferModel.fromMap(e.data())).toList());
  }

  Future<void> rejectShopOffer(
      {required ProductRequestModel requestModel,
      required ShopOfferModel offerModel}) async {
    List<String> ignoredlist = requestModel.ignored;
    ignoredlist.add(FirebaseAuth.instance.currentUser!.uid);
    await firestore
        .collection('productRequest')
        .doc(requestModel.docId)
        .collection('offers')
        .doc(offerModel.docId)
        .update({'isRejected': true});
  }

  Future<void> acceptShopOffer(
      {required ProductRequestModel requestModel,
      required ShopOfferModel offerModel}) async {
    await firestore
        .collection('productRequest')
        .doc(requestModel.docId)
        .update({'isApproved': true, 'shopId': offerModel.shopId});
    await firestore
        .collection('productRequest')
        .doc(requestModel.docId)
        .collection('offers')
        .doc(offerModel.docId)
        .update({'isAccepted': true});
  }

  Future<void> declineRequest(
      {required ProductRequestModel model, required String shopId}) async {
    List<String> list = model.ignored;
    list.add(shopId);
    await firestore
        .collection('productRequest')
        .doc(model.docId)
        .update({'ignored': list});
  }

  double calculateDistance(LatLng center, LatLng request) {
    const double earthRadiusKm = 6371.0;

    double latDiff = degreesToRadians(request.latitude - center.latitude);
    double lngDiff = degreesToRadians(request.longitude - center.longitude);

    double a = pow(sin(latDiff / 2), 2) +
        cos(degreesToRadians(center.latitude)) *
            cos(degreesToRadians(request.latitude)) *
            pow(sin(lngDiff / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }
}
