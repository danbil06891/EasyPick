import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pick/models/offer_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/request_model.dart';

class OfferRepo {
  static final instance = OfferRepo();
  final firestore = FirebaseFirestore.instance;

  Stream<OfferModel?> checkIfOfferExist({required RequestModel requestModel}) {
    return firestore
        .collection('requests')
        .doc(requestModel.docId)
        .collection('offers')
        .where('riderId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return OfferModel.fromMap(data);
      } else {
        return null;
      }
    });
  }

  Stream<List<OfferModel>> getMyOffers({required RequestModel requestModel}) {
    return firestore
        .collection('requests')
        .doc(requestModel.docId)
        .collection('offers')
        .where('isAccepted', isEqualTo: false)
        .where('isRejected', isEqualTo: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OfferModel.fromMap(e.data())).toList());
  }

  Future<void> acceptUserOffer(
      RequestModel requestModel, OfferModel offerModel) async {
    String docId = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore
        .collection('requests')
        .doc(requestModel.docId)
        .collection('offers')
        .doc(docId)
        .set(offerModel.copyWith(docId: docId).toMap());
  }

  Future<void> createOffer(
      RequestModel requestModel, OfferModel offerModel) async {
    String docId = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore
        .collection('requests')
        .doc(requestModel.docId)
        .collection('offers')
        .doc(docId)
        .set(offerModel.copyWith(docId: docId).toMap());
  }

  Future<void> rejectOffer(
      {required RequestModel requestModel,
      required OfferModel offerModel}) async {
    List<String> ignoredlist = requestModel.ignored;
    ignoredlist.add(FirebaseAuth.instance.currentUser!.uid);
    await firestore
        .collection('requests')
        .doc(requestModel.docId)
        .collection('offers')
        .doc(offerModel.docId)
        .update({'isRejected': true});
  }

  Future<void> acceptRiderOffer(
      {required RequestModel requestModel,
      required OfferModel offerModel}) async {
    await firestore
        .collection('requests')
        .doc(requestModel.docId)
        .update({'isApproved': true, 'riderId': offerModel.riderId});
    await firestore
        .collection('requests')
        .doc(requestModel.docId)
        .collection('offers')
        .doc(offerModel.docId)
        .update({'isAccepted': true});
  }
}
