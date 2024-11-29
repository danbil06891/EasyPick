import 'package:flutter/material.dart';

enum OrderEnum {
  pending,
  accepted,
  rejected,
  assigned,
  picked,
  arrived,
  delivered,
}

extension TextColor on OrderEnum {
  Color getColor() {
    switch (this) {
      case OrderEnum.pending:
        return Colors.deepOrange;
      case OrderEnum.accepted:
        return Colors.green;
      case OrderEnum.rejected:
        return Colors.red;
      case OrderEnum.assigned:
        return Colors.green;
      case OrderEnum.picked:
        return Colors.green;
      case OrderEnum.arrived:
        return Colors.blue;
      case OrderEnum.delivered:
        return Colors.green;
    }
  }
}

extension Name on OrderEnum {
  String getName() {
    switch (this) {
      case OrderEnum.pending:
        return "Pending";
      case OrderEnum.accepted:
        return "Accepted";
      case OrderEnum.rejected:
        return "Rejected";
      case OrderEnum.assigned:
        return "Assigned";
      case OrderEnum.picked:
        return "Picked";
      case OrderEnum.arrived:
      return "Arrived";
      case OrderEnum.delivered:
        return "Delivered";
    }
  }
}
