import 'package:flutter/material.dart';

class Cart {
  final String? serviceId;
  double numberHours;
  final String? name;
  final String? status;
  final String? price;
  final String? category;
  final String? img;

  Cart(
      {
        required this.serviceId,
        required this.numberHours,
        required this.name,
        required this.status,
        required this.price,
        required this.category,
        required this.img,
        });

  Cart.fromMap(Map<dynamic, dynamic> data)
      :
        serviceId = data['serviceId'],
        numberHours = data['numberHours'].toDouble(),
        name = data['name'],
        status = data['status'],
        price = data['price'],
        category = data['category'],
        img = data['img'];

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'numberHours': numberHours,
      'name': name,
      'status': status,
      'price': price,
      'category': category,
      'img': img,
    };
  }

  Map<String, dynamic> numberHourMap() {
    return {
      'serviceId': serviceId,
      'numberHours': numberHours,
      'name': name,
      'status': status,
      'price': price,
      'category': category,
      'img': img,
    };
  }
}