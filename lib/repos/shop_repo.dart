import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pick/models/user_model.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class ShopRepo {
  static final instance = ShopRepo();
  final firestore = FirebaseFirestore.instance;

  Stream<List<UserModel>> getAllUsersByGeoPackage(
      {required UserModel userModel, required int rad}) {
    final geo = GeoFlutterFire();
    final firestore = FirebaseFirestore.instance;
    GeoFirePoint center = geo.point(
      latitude: userModel.geoFirePoint.latitude,
      longitude: userModel.geoFirePoint.longitude,
    );

    var queryRef =
        firestore.collection('users').where('type', isEqualTo: 'Shop Keeper');
    var stream = geo.collection(collectionRef: queryRef).within(
          center: center,
          radius: rad.toDouble(),
          field: 'geoFirePoint',
          strictMode: true,
        );

    return stream.map((event) => event.map((document) {
          var user = UserModel.fromMap(document.data() as dynamic);
          return user;
        }).toList());
  }
}
