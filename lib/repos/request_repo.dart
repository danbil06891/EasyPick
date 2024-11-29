import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pick/models/user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/product_request_model.dart';
import '../models/request_model.dart';
import 'dart:math' show atan2, cos, pi, pow, sin, sqrt;

class RequestRepo {
  static final RequestRepo instance = RequestRepo();
  final firestore = FirebaseFirestore.instance;
  Future<List<RequestModel>> getAllRequests() async {
    List<RequestModel> requests = [];
    try {
      final response = await FirebaseFirestore.instance
          .collection('requests')
          .orderBy('dateAndTime', descending: true)
          .get();
      if (response.docs.isNotEmpty) {
        for (var doc in response.docs) {
          requests.add(RequestModel.fromMap(doc.data()));
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return requests;
  }

  Future<void> addRequest(
      {required RequestModel requestModel, required String orderId}) async {
    String id = DateTime.now().toIso8601String();
    await firestore
        .collection('requests')
        .doc(id)
        .set(requestModel.copyWith(docId: id).toMap());
  }

  Future<void> deleteRequest(String docId) async {
    await firestore.collection('requests').doc(docId).delete();
  }

  Stream<List<RequestModel>> getRequestById(String id) {
    return firestore
        .collection('requests')
        .where('uid', isEqualTo: id)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => RequestModel.fromMap(e.data())).toList());
  }

  // Stream<List<RequestModel>> getAllRequest(UserModel userModel) {
  //   return firestore
  //       .collection('requests')
  //       .where('requestType', isEqualTo: userModel.type)
  //       .snapshots()
  //       .map((event) =>
  //           event.docs.map((e) => RequestModel.fromMap(e.data())).toList());
  // }

  Stream<List<RequestModel>> getAllRequest(UserModel userModel) {
    final centerLatLng = LatLng(
        userModel.geoFirePoint.latitude, userModel.geoFirePoint.longitude);

    return firestore
        .collection('requests')
        .where('isApproved', isEqualTo: false)
        .snapshots()
        .distinct()
        .map((event) => event.docs
                .map((e) => RequestModel.fromMap(e.data()))
                .where((request) {
              LatLng requestLatLng = LatLng(request.geoFirePoint.latitude,
                  request.geoFirePoint.longitude);
              log('requestLatLng: $requestLatLng');
              log('radius: ${request.radius}');
              final radius = request.radius * 1000;
              final distance = calculateDistance(centerLatLng, requestLatLng);
              return distance <= radius;
            }).toList());
  }
  // Stream<List<RequestModel>> getAllRequest(UserModel userModel) {
  //   final centerLatLng = LatLng(
  //       userModel.geoFirePoint.latitude, userModel.geoFirePoint.longitude);

  //   return firestore
  //       .collection('requests')
  //       // .orderBy('isApproved', descending: false)
  //       .snapshots()
  //       .distinct()
  //       .map((event) => event.docs
  //               .map((e) => RequestModel.fromMap(e.data()))
  //               .where((request) {
  //             LatLng requestLatLng = LatLng(request.geoFirePoint.latitude,
  //                 request.geoFirePoint.longitude);
  //             log('requestLatLng: $requestLatLng');
  //             log('radius: ${request.radius}');
  //             final radius = request.radius * 1000;
  //             final distance = calculateDistance(centerLatLng, requestLatLng);
  //             return distance <= radius;
  //           }).toList());
  // }

  Stream<RequestModel?> checkIfOrderRequestExist({required String orderId}) {
    return firestore
        .collection('requests')
        .where('orderId', isEqualTo: orderId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return RequestModel.fromMap(data);
      } else {
        return null;
      }
    });
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

  Future<void> declineRequest(
      {required RequestModel model, required String riderId}) async {
    List<String> list = model.ignored;
    list.add(riderId);
    await firestore
        .collection('requests')
        .doc(model.docId)
        .update({'ignored': list});
  }
}
