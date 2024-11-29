

class ItemModel {
  String itemId;
  String authId;
  String name;
  String description;
  String price;
  String image;
  String category;
  bool isDeleted;
  int createdAt;
  int quantity;
  ItemModel({
    required this.itemId,
    required this.authId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.isDeleted,
    required this.createdAt,
    this.quantity=0
  });

  ItemModel copyWith({
    String? itemId,
    String? authId,
    String? name,
    String? description,
    String? price,
    String? image,
    String? category,
    bool? isDeleted,
    int? createdAt,
    int? quantity,
  }) {
    return ItemModel(
      itemId: itemId ?? this.itemId,
      authId: authId ?? this.authId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemId': itemId,
      'authId': authId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'quantity': quantity,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      itemId: map['itemId'] as String,
      authId: map['authId'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] as String,
      image: map['image'] as String,
      category: map['category'] as String,
      isDeleted: map['isDeleted'] as bool,
      createdAt: map['createdAt'] ??0,
      quantity: map['quantity'] ??0,
    );
  }


}
