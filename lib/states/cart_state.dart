import 'dart:developer';

import 'package:easy_pick/enums/order_enums.dart';
import 'package:easy_pick/models/item_model.dart';
import 'package:easy_pick/models/order_model.dart';
import 'package:easy_pick/repos/order_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartState extends ChangeNotifier {
  Map<String, ItemModel> _cartItems = {};
  Map<String, ItemModel> get cartItems => _cartItems;
  int get cartItemCount => _cartItems.length;

  double get totalAmount {
    double total = 0.0;
    _cartItems.forEach((itemId, item) {
      final itemPrice = double.parse(item.price);
      final itemQuantity = item.quantity;
      total += itemPrice * itemQuantity;
    });
    return total;
  }

  void addToCart(ItemModel item) {
    if (_cartItems.containsKey(item.itemId)) {
      final updatedItem = _cartItems[item.itemId]!
          .copyWith(quantity: _cartItems[item.itemId]!.quantity + 1);
      _cartItems[item.itemId] = updatedItem;
      log("cart item updated  ${_cartItems[item.itemId]!.name}, quantity ${_cartItems[item.itemId]!.quantity} ");
    } else {
      _cartItems[item.itemId] = item.copyWith(quantity: 1);
      log("cart item  ${_cartItems[item.itemId]!.name}, quantity ${_cartItems[item.itemId]!.quantity} ");
    }
    notifyListeners();
  }

  void removeFromCart(ItemModel item) {
    if (_cartItems.containsKey(item.itemId)) {
      final updatedItem = _cartItems[item.itemId]!
          .copyWith(quantity: _cartItems[item.itemId]!.quantity - 1);
      if (updatedItem.quantity <= 0) {
        _cartItems.remove(item.itemId);
      } else {
        _cartItems[item.itemId] = updatedItem;
      }
      notifyListeners();
    }
  }

  Future<void> placeOrder(Map<String, ItemModel> cartItems) async {
    Map<String, List<ItemModel>> groupedItems = {};

    // Group items based on shop ID (authId)
    for (ItemModel item in cartItems.values) {
      if (groupedItems.containsKey(item.authId)) {
        groupedItems[item.authId]!.add(item);
      } else {
        groupedItems[item.authId] = [item];
      }
    }

    // Create separate orders for each shop
    for (String shopId in groupedItems.keys) {
      List<ItemModel> shopItems = groupedItems[shopId]!;

      // Calculate total amount for the shop
      double totalAmount = 0;
      for (ItemModel item in shopItems) {
        double price = double.parse(item.price);
        totalAmount += price * item.quantity;
      }

      OrderModel order = OrderModel(
        orderId: "", // Generate a unique order ID
        shopId: shopId,
        items: shopItems,
        totalAmount: totalAmount.toString(),
        orderPlacedDate: DateTime.now().millisecondsSinceEpoch,
        orderEnum: OrderEnum.pending,
        cancelReason: '',
        orderDeliveredDate: 0,
        riderId: '',
        userId: FirebaseAuth.instance.currentUser!.uid,
        isOrderFromRequest: false,
        productRequestModel: null,
      );

      // Save order document to Firestore
      await OrderRepo.instance.addOrder(order);

      // Clear cart items for the shop
      // List<String> itemIds = shopItems.map((item) => item.itemId).toList();
      // await FirebaseFirestore.instance
      //     .collection('cart')
      //     .doc(shopId)
      //     .update({'items': FieldValue.arrayRemove(itemIds)});
    }

    // Clear the entire cart after placing orders
    // (You may need to implement this functionality in your CartProvider)
    clearCart();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
