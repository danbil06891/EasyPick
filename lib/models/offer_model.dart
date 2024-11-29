// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OfferModel {
  final String reqId;
  final String docId;
  final String orderId;
  final String price;
  final String riderId;
  final bool isAccepted;
  final bool isRejected;
  final int createdAt;
  OfferModel({
    required this.reqId,
    required this.docId,
    required this.orderId,
    required this.price,
    required this.riderId,
    required this.isAccepted,
    required this.isRejected,
    required this.createdAt,
  });



  OfferModel copyWith({
    String? reqId,
    String? docId,
    String? orderId,
    String? price,
    String? riderId,
    bool? isAccepted,
    bool? isRejected,
    int? createdAt,
  }) {
    return OfferModel(
      reqId: reqId ?? this.reqId,
      docId: docId ?? this.docId,
      orderId: orderId ?? this.orderId,
      price: price ?? this.price,
      riderId: riderId ?? this.riderId,
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
      'riderId': riderId,
      'isAccepted': isAccepted,
      'isRejected': isRejected,
      'createdAt': createdAt,
    };
  }

  factory OfferModel.fromMap(Map<String, dynamic> map) {
    return OfferModel(
      reqId: map['reqId'] as String,
      docId: map['docId'] as String,
      orderId: map['orderId'] as String,
      price: map['price'] as String,
      riderId: map['riderId'] as String,
      isAccepted: map['isAccepted'] as bool,
      isRejected: map['isRejected'] as bool,
      createdAt: map['createdAt'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OfferModel.fromJson(String source) => OfferModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OfferModel(reqId: $reqId, docId: $docId, orderId: $orderId, price: $price, riderId: $riderId, isAccepted: $isAccepted, isRejected: $isRejected, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant OfferModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.reqId == reqId &&
      other.docId == docId &&
      other.orderId == orderId &&
      other.price == price &&
      other.riderId == riderId &&
      other.isAccepted == isAccepted &&
      other.isRejected == isRejected &&
      other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return reqId.hashCode ^
      docId.hashCode ^
      orderId.hashCode ^
      price.hashCode ^
      riderId.hashCode ^
      isAccepted.hashCode ^
      isRejected.hashCode ^
      createdAt.hashCode;
  }
}
