// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class RequestModel {
  String orderId;
  String shopId;
  String docId;
  String price;
  int radius;
  String discription;
  GeoFirePoint geoFirePoint;
  int createdAt;
  bool isApproved;
  bool isDeleted;
  String? riderId;
  List<String> ignored;
  String userId;
  RequestModel({
    required this.orderId,
    required this.shopId,
    required this.docId,
    required this.price,
    required this.radius,
    required this.discription,
    required this.geoFirePoint,
    required this.createdAt,
    required this.isApproved,
    required this.isDeleted,
    required this.userId,
    this.riderId,
    required this.ignored,
  });


  RequestModel copyWith({
    String? orderId,
    String? shopId,
    String? docId,
    String? price,
    int? radius,
    String? discription,
    GeoFirePoint? geoFirePoint,
    int? createdAt,
    bool? isApproved,
    bool? isDeleted,
    String? riderId,
    List<String>? ignored,
    String? userId,
  }) {
    return RequestModel(
      orderId: orderId ?? this.orderId,
      shopId: shopId ?? this.shopId,
      docId: docId ?? this.docId,
      price: price ?? this.price,
      radius: radius ?? this.radius,
      userId: userId ?? this.userId,
      discription: discription ?? this.discription,
      geoFirePoint: geoFirePoint ?? this.geoFirePoint,
      createdAt: createdAt ?? this.createdAt,
      isApproved: isApproved ?? this.isApproved,
      isDeleted: isDeleted ?? this.isDeleted,
      riderId: riderId ?? this.riderId,
      ignored: ignored ?? this.ignored,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'shopId': shopId,
      'docId': docId,
      'price': price,
      'radius': radius,
      'discription': discription,
      'geoFirePoint': geoFirePoint.data,
      'createdAt': createdAt,
      'isApproved': isApproved,
      'isDeleted': isDeleted,
      'riderId': riderId,
      'ignored': ignored,
      'userId': userId,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      orderId: map['orderId'] as String,
      shopId: map['shopId'] as String,
      docId: map['docId'] as String,
      price: map['price'] as String,
      radius: map['radius'] as int,
      userId: map['userId'] as String,
      discription: map['discription'] as String,
       geoFirePoint: GeoFirePoint(
        map['geoFirePoint']['geopoint'].latitude,
        map['geoFirePoint']['geopoint'].longitude,
      ),
      createdAt: map['createdAt'] as int,
      isApproved: map['isApproved'] as bool,
      isDeleted: map['isDeleted'] as bool,
      riderId: map['riderId'] != null ? map['riderId'] as String : null,
     ignored: List<String>.from(map['ignored'] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory RequestModel.fromJson(String source) => RequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RequestModel(orderId: $orderId, shopId: $shopId, docId: $docId, price: $price, radius: $radius, discription: $discription, geoFirePoint: $geoFirePoint, createdAt: $createdAt, isApproved: $isApproved, isDeleted: $isDeleted, riderId: $riderId, ignored: $ignored)';
  }

  @override
  bool operator ==(covariant RequestModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.orderId == orderId &&
      other.shopId == shopId &&
      other.docId == docId &&
      other.price == price &&
      other.radius == radius &&
      other.discription == discription &&
      other.geoFirePoint == geoFirePoint &&
      other.createdAt == createdAt &&
      other.isApproved == isApproved &&
      other.isDeleted == isDeleted &&
      other.riderId == riderId &&
      listEquals(other.ignored, ignored);
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
      shopId.hashCode ^
      docId.hashCode ^
      price.hashCode ^
      radius.hashCode ^
      discription.hashCode ^
      geoFirePoint.hashCode ^
      createdAt.hashCode ^
      isApproved.hashCode ^
      isDeleted.hashCode ^
      riderId.hashCode ^
      ignored.hashCode;
  }
}
