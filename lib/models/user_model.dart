import 'package:geoflutterfire2/geoflutterfire2.dart';

class UserModel {
  String uid;
  String name;
  String email;
  String phoneNo;
  String address;
  String type;
  String imageUrl;
  String cnic;
  GeoFirePoint geoFirePoint;
  int createdAt;
  bool isApproved;
  bool isBlocked;
  String? shopName;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.address,
    required this.type,
    required this.imageUrl,
    required this.cnic,
    required this.geoFirePoint,
    this.createdAt = 0,
    this.isApproved = false,
    this.isBlocked = false,
    this.shopName = '',
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNo,
    String? address,
    String? type,
    String? imageUrl,
    String? cnic,
    GeoFirePoint? geoFirePoint,
    int? createdAt,
    bool? isApproved,
    bool? isBlocked,
    String? shopName,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      address: address ?? this.address,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      cnic: cnic ?? this.cnic,
      geoFirePoint: geoFirePoint ?? this.geoFirePoint,
      createdAt: createdAt ?? this.createdAt,
      isApproved: isApproved ?? this.isApproved,
      isBlocked: isBlocked ?? this.isBlocked,
      shopName: shopName ?? this.shopName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'address': address,
      'type': type,
      'imageUrl': imageUrl,
      'cnic': cnic,
      'geoFirePoint': geoFirePoint.data,
      'createdAt': createdAt,
      'isApproved': isApproved,
      'isBlocked': isBlocked,
      'shopName': shopName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    print('uid---------------------- ${map['uid']}');
    print('name---------------------- ${map['name']}');
    print('email---------------------- ${map['email']}');
    print('phoneNo---------------------- ${map['phoneNo']}');
    print('address---------------------- ${map['address']}');
    print('type---------------------- ${map['type']}');
    print('imageUrl---------------------- ${map['imageUrl']}');
    print('cnic---------------------- ${map['cnic']}');
    print('geoFirePoint---------------------- ${map['geoFirePoint']}');
    print('createdAt---------------------- ${map['createdAt']}');
    print('isApproved---------------------- ${map['isApproved']}');
    print('isBlocked---------------------- ${map['isBlocked']}');
    print('shopName---------------------- ${map['shopName']}');
    
    return UserModel(
      uid: map['uid'] ??'',
      name: map['name'] ??'',
      email: map['email'] ??'',
      phoneNo: map['phoneNo'] ??'',
      address: map['address'] ??'',
      type: map['type'] ??'',
      imageUrl: map['imageUrl'] ??'',
      cnic: map['cnic'] ??'',
      geoFirePoint: GeoFirePoint(
        map['geoFirePoint']['geopoint'].latitude,
        map['geoFirePoint']['geopoint'].longitude,
      ),
      createdAt: map['createdAt'] ?? 0,
      isApproved: map['isApproved'] ?? false,
      isBlocked: map['isBlocked'] ?? false,
      shopName: map['shopName'] ?? '',
    );
  }
}
