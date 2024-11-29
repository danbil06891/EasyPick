// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HouseModel {
  String uid;
  String docId;
  String houseNo;
  String houseAddress;
  String houseFloor;
  String housePrice;
  String houseArea;
  String houseBedroom;
  String houseBathroom;
  String houseType;
  String houseImage;
  HouseModel({
    required this.uid,
    required this.docId,
    required this.houseNo,
    required this.houseAddress,
    required this.houseFloor,
    required this.housePrice,
    required this.houseArea,
    required this.houseBedroom,
    required this.houseBathroom,
    required this.houseType,
    required this.houseImage,
  });

  

  HouseModel copyWith({
    String? uid,
    String? docId,
    String? houseNo,
    String? houseAddress,
    String? houseFloor,
    String? housePrice,
    String? houseArea,
    String? houseBedroom,
    String? houseBathroom,
    String? houseType,
    String? houseImage,
  }) {
    return HouseModel(
      uid: uid ?? this.uid,
      docId: docId ?? this.docId,
      houseNo: houseNo ?? this.houseNo,
      houseAddress: houseAddress ?? this.houseAddress,
      houseFloor: houseFloor ?? this.houseFloor,
      housePrice: housePrice ?? this.housePrice,
      houseArea: houseArea ?? this.houseArea,
      houseBedroom: houseBedroom ?? this.houseBedroom,
      houseBathroom: houseBathroom ?? this.houseBathroom,
      houseType: houseType ?? this.houseType,
      houseImage: houseImage ?? this.houseImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'docId': docId,
      'houseNo': houseNo,
      'houseAddress': houseAddress,
      'houseFloor': houseFloor,
      'housePrice': housePrice,
      'houseArea': houseArea,
      'houseBedroom': houseBedroom,
      'houseBathroom': houseBathroom,
      'houseType': houseType,
      'houseImage': houseImage,
    };
  }

  factory HouseModel.fromMap(Map<String, dynamic> map) {
    return HouseModel(
      uid: map['uid'] as String,
      docId: map['docId'] as String,
      houseNo: map['houseNo'] as String,
      houseAddress: map['houseAddress'] as String,
      houseFloor: map['houseFloor'] as String,
      housePrice: map['housePrice'] as String,
      houseArea: map['houseArea'] as String,
      houseBedroom: map['houseBedroom'] as String,
      houseBathroom: map['houseBathroom'] as String,
      houseType: map['houseType'] as String,
      houseImage: map['houseImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HouseModel.fromJson(String source) => HouseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HouseModel(uid: $uid, docId: $docId, houseNo: $houseNo, houseAddress: $houseAddress, houseFloor: $houseFloor, housePrice: $housePrice, houseArea: $houseArea, houseBedroom: $houseBedroom, houseBathroom: $houseBathroom, houseType: $houseType, houseImage: $houseImage)';
  }

  @override
  bool operator ==(covariant HouseModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.docId == docId &&
      other.houseNo == houseNo &&
      other.houseAddress == houseAddress &&
      other.houseFloor == houseFloor &&
      other.housePrice == housePrice &&
      other.houseArea == houseArea &&
      other.houseBedroom == houseBedroom &&
      other.houseBathroom == houseBathroom &&
      other.houseType == houseType &&
      other.houseImage == houseImage;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      docId.hashCode ^
      houseNo.hashCode ^
      houseAddress.hashCode ^
      houseFloor.hashCode ^
      housePrice.hashCode ^
      houseArea.hashCode ^
      houseBedroom.hashCode ^
      houseBathroom.hashCode ^
      houseType.hashCode ^
      houseImage.hashCode;
  }
}
