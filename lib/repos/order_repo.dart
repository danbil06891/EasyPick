import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../enums/order_enums.dart';
import '../models/order_model.dart';

class OrderRepo {
  static final instance = OrderRepo();
  final firestore = FirebaseFirestore.instance;
  Future<void> addOrder(OrderModel orderModel) async {
    String docId = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore
        .collection("orders")
        .doc(docId)
        .set(orderModel.copyWith(orderId: docId).toMap());
  }

  Stream<List<OrderModel>> getUserPendingOrders() {
    return firestore
        .collection("orders")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.pending.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getUserRejectedOrder() {
    return firestore
        .collection("orders")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.rejected.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getUserPickedOrder() {
    return firestore
        .collection("orders")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.picked.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getUserDeliveredOrders() {
    return firestore
        .collection("orders")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.delivered.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getShopPickedOrder() {
    return firestore
        .collection("orders")
        .where("shopId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.picked.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getShopArrivedOrder() {
    return firestore
        .collection("orders")
        .where("shopId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.arrived.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getShopDeliveredOrders() {
    return firestore
        .collection("orders")
        .where("shopId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.delivered.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getShopRejectedOrders() {
    return firestore
        .collection("orders")
        .where("shopId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.rejected.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getUserAssignedOrders() {
    return firestore
        .collection("orders")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.assigned.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getUserAcceptedOrders() {
    return firestore
        .collection("orders")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.accepted.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getUserArrivedOrder() {
    return firestore
        .collection("orders")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.arrived.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getShopPendingOrders() {
    return firestore
        .collection("orders")
        .where("shopId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.pending.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getShopAcceptedOrders() {
    return firestore
        .collection("orders")
        .where("shopId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.accepted.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getShopAssignedOrders() {
    return firestore
        .collection("orders")
        .where("shopId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.assigned.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getRiderAssignedOrder() {
    return firestore
        .collection("orders")
        .where("riderId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.assigned.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getRiderCompletedOrders() {
    return firestore
        .collection("orders")
        .where("riderId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.delivered.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getRiderPickedOrder() {
    return firestore
        .collection("orders")
        .where("riderId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.picked.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Stream<List<OrderModel>> getRiderArrivedOrder() {
    return firestore
        .collection("orders")
        .where("riderId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("orderEnum", isEqualTo: OrderEnum.arrived.index)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => OrderModel.fromMap(e.data())).toList());
  }

  Future<void> acceptOrder(
      {required String orderId, required OrderEnum orderEnum}) async {
    await firestore
        .collection("orders")
        .doc(orderId)
        .update({"orderEnum": orderEnum.index});
  }

  Future<void> rejectOrder(
      {required String orderId, required OrderEnum orderEnum}) async {
    await firestore
        .collection("orders")
        .doc(orderId)
        .update({"orderEnum": orderEnum.index});
  }

  Future<void> pickedOrder(
      {required String orderId, required OrderEnum orderEnum}) async {
    await firestore
        .collection("orders")
        .doc(orderId)
        .update({"orderEnum": orderEnum.index});
  }

  Future<void> deliveredOrder(
      {required String orderId, required OrderEnum orderEnum}) async {
    await firestore.collection("orders").doc(orderId).update({
      "orderEnum": orderEnum.index,
      'orderDeliveredDate': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<void> arrivedOrder(
      {required String orderId, required OrderEnum orderEnum}) async {
    await firestore
        .collection("orders")
        .doc(orderId)
        .update({"orderEnum": orderEnum.index});
  }

  Future<void> assignOrderToRider(
      {required String orderId,
      required OrderEnum orderEnum,
      required String riderId}) async {
    await firestore
        .collection("orders")
        .doc(orderId)
        .update({"orderEnum": orderEnum.index, "riderId": riderId});
  }
}
