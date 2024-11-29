// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class ProductRequestModel {
  final String userId;
  final String selectedCategory;
  final String selectedSubCategory;
  final String shopId;
  final String docId;
  final String price;
  final int radius;
  final String discription;
  final GeoFirePoint geoFirePoint;
  final bool isApproved;
  final bool isDeleted;
  final List<String> ignored;
  final int createdAt;

  ProductRequestModel({
    required this.shopId,
    required this.docId,
    required this.price,
    required this.radius,
    required this.discription,
    required this.geoFirePoint,
    required this.isApproved,
    required this.isDeleted,
    required this.ignored,
    required this.userId,
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.createdAt,
  });

  ProductRequestModel copyWith({
    String? shopId,
    String? docId,
    String? price,
    int? radius,
    String? discription,
    GeoFirePoint? geoFirePoint,
    bool? isApproved,
    bool? isDeleted,
    List<String>? ignored,
    String? userId,
    String? selectedCategory,
    String? selectedSubCategory,
    int? createdAt,
  }) {
    return ProductRequestModel(
      shopId: shopId ?? this.shopId,
      docId: docId ?? this.docId,
      price: price ?? this.price,
      radius: radius ?? this.radius,
      discription: discription ?? this.discription,
      geoFirePoint: geoFirePoint ?? this.geoFirePoint,
      isApproved: isApproved ?? this.isApproved,
      isDeleted: isDeleted ?? this.isDeleted,
      ignored: ignored ?? this.ignored,
      userId: userId ?? this.userId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      createdAt: createdAt ?? this.createdAt,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shopId': shopId,
      'docId': docId,
      'price': price,
      'radius': radius,
      'discription': discription,
      'geoFirePoint': geoFirePoint.data,
      'isApproved': isApproved,
      'isDeleted': isDeleted,
      'ignored': ignored,
      'userId': userId,
      'selectedCategory': selectedCategory,
      'selectedSubCategory': selectedSubCategory,
      'createdAt': createdAt,
    };
  }

  factory ProductRequestModel.fromMap(Map<String, dynamic> map) {
    return ProductRequestModel(
      userId: map['userId'] as String,
      shopId: map['shopId'] as String,
      docId: map['docId'] as String,
      price: map['price'] as String,
      radius: map['radius'] as int,
      discription: map['discription'] as String,
      geoFirePoint: GeoFirePoint(
        map['geoFirePoint']['geopoint'].latitude,
        map['geoFirePoint']['geopoint'].longitude,
      ),
      createdAt: map['createdAt'] as int,
      isApproved: map['isApproved'] as bool,
      isDeleted: map['isDeleted'] as bool,
      selectedCategory: map['selectedCategory'] as String,
      selectedSubCategory: map['selectedSubCategory'] as String,
      ignored: List<String>.from(map['ignored'] as List<dynamic>),
    );
  }


}
