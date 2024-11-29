// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ShopOfferModel {
  final String reqId;
  final String docId;
  final String orderId;
  final String price;
  final String shopId;
  final bool isAccepted;
  final bool isRejected;
  final int createdAt;
  ShopOfferModel({
    required this.reqId,
    required this.docId,
    required this.orderId,
    required this.price,
    required this.shopId,
    required this.isAccepted,
    required this.isRejected,
    required this.createdAt,
  });

  ShopOfferModel copyWith({
    String? reqId,
    String? docId,
    String? orderId,
    String? price,
    String? shopId,
    bool? isAccepted,
    bool? isRejected,
    int? createdAt,
  }) {
    return ShopOfferModel(
      reqId: reqId ?? this.reqId,
      docId: docId ?? this.docId,
      orderId: orderId ?? this.orderId,
      price: price ?? this.price,
      shopId: shopId ?? this.shopId,
      isAccepted: isAccepted ?? this.isAccepted,
      isRejected: isRejected ?? this.isRejected,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reqId': reqId,
      'docId': docId,
      'orderId': orderId,
      'price': price,
      'shopId': shopId,
      'isAccepted': isAccepted,
      'isRejected': isRejected,
      'createdAt': createdAt,
    };
  }

  factory ShopOfferModel.fromMap(Map<String, dynamic> map) {
    return ShopOfferModel(
      reqId: map['reqId'] as String,
      docId: map['docId'] as String,
      orderId: map['orderId'] as String,
      price: map['price'] as String,
      shopId: map['shopId'] as String,
      isAccepted: map['isAccepted'] as bool,
      isRejected: map['isRejected'] as bool,
      createdAt: map['createdAt'] as int,
    );
  }
}
