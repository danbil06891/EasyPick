import 'package:easy_pick/models/product_request_model.dart';
import 'package:intl/intl.dart';
import '../enums/order_enums.dart';
import 'item_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String shopId;
  final String riderId;
  final String totalAmount;
  final List<ItemModel>? items;
  final OrderEnum orderEnum;
  final ProductRequestModel? productRequestModel;
  final int orderPlacedDate;
  final int orderDeliveredDate;
  String cancelReason;
  final bool isOrderFromRequest;
  OrderModel({
    required this.orderId,
    required this.userId,
    required this.shopId,
    required this.riderId,
    required this.totalAmount,
    this.items,
    this.productRequestModel,
    required this.orderEnum,
    required this.orderPlacedDate,
    required this.orderDeliveredDate,
    required this.cancelReason,
    required this.isOrderFromRequest,
  });

  OrderModel copyWith({
    String? orderId,
    String? userId,
    String? shopId,
    String? riderId,
    String? totalAmount,
    List<ItemModel>? items,
    OrderEnum? orderEnum,
    int? orderPlacedDate,
    int? orderDeliveredDate,
    String? cancelReason,
    bool? isOrderFromRequest,
    ProductRequestModel? productRequestModel,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      shopId: shopId ?? this.shopId,
      riderId: riderId ?? this.riderId,
      totalAmount: totalAmount ?? this.totalAmount,
      items: items ?? this.items,
      orderEnum: orderEnum ?? this.orderEnum,
      orderPlacedDate: orderPlacedDate ?? this.orderPlacedDate,
      orderDeliveredDate: orderDeliveredDate ?? this.orderDeliveredDate,
      cancelReason: cancelReason ?? this.cancelReason,
      isOrderFromRequest: isOrderFromRequest ?? this.isOrderFromRequest,
      productRequestModel: productRequestModel ?? this.productRequestModel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'userId': userId,
      'shopId': shopId,
      'riderId': riderId,
      'totalAmount': totalAmount,
      'items': items?.map((x) => x.toMap()).toList(),
      'orderEnum': orderEnum.index,
      'orderPlacedDate': orderPlacedDate,
      'orderDeliveredDate': orderDeliveredDate,
      'cancelReason': cancelReason,
      'isOrderFromRequest': isOrderFromRequest,
      'productRequestModel': productRequestModel?.toMap(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      shopId: map['shopId'] ?? '',
      riderId: map['riderId'] ?? '',
      totalAmount: map['totalAmount'] ?? '',
      items: List<ItemModel>.from(
        (map['items'] as List<dynamic>).map<ItemModel>(
          (x) => ItemModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      orderEnum: OrderEnum.values[map["orderEnum"]],
      orderPlacedDate: map['orderPlacedDate'] as int? ?? 0,
      orderDeliveredDate: map['orderDeliveredDate'] as int? ?? 0,
      cancelReason: map['cancelReason'] ?? '',
      isOrderFromRequest: map['isOrderFromRequest'] ?? false,
      productRequestModel: map['productRequestModel'] == null
          ? null
          : ProductRequestModel.fromMap(
              map['productRequestModel'] as Map<String, dynamic>),
    );
  }
  String get formattedOrderPlacedDate {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(orderPlacedDate);
    final formatter = DateFormat('MMMM dd, yyyy hh:mm a');
    return formatter.format(dateTime);
  }

  String get formattedOrderDeliveredDate {
    if (orderDeliveredDate == 0) {
      return 'Not delivered yet';
    }
    final dateTime = DateTime.fromMillisecondsSinceEpoch(orderDeliveredDate);
    final formatter = DateFormat('MMMM dd, yyyy hh:mm a');
    return formatter.format(dateTime);
  }
}
