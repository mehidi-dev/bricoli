import 'dart:convert';
import 'package:flutter/cupertino.dart';

import '../utils/api_http.dart';
import '../utils/api_utils.dart';
import '../utils/toast.dart';



class Order {
  Order({
    required this.id,
    required this.ordernumber,
    required this.username,
    required this.invoicenumber,
    required this.product,
    required this.price,
    required this.qnt,
    required this.weight,
    required this.clientname,
    required this.phone1,
    required this.phone2,
    required this.address,
    required this.state,
    required this.district,
    required this.Categoryy,
    required this.laststatus,
    required this.payementready,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String ordernumber;
  String username;
  String invoicenumber;
  String product;
  int price;
  int qnt;
  int weight;
  String clientname;
  String phone1;
  String phone2;
  String address;
  String state;
  String district;
  int Categoryy;
  String laststatus;
  String payementready;
  List<String> status;
  String createdAt;
  String updatedAt;
  int v;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["_id"],
    ordernumber: json["ordernumber"],
    username: json["username"],
    invoicenumber: json["invoicenumber"]?? "",
    product: json["product"],
    price: json["price"],
    qnt: json["qnt"],
    weight: json["weight"],
    clientname: json["clientname"],
    phone1: json["phone1"],
    phone2: json["phone2"] ?? "",
    address: json["address"],
    state: json["state"],
    district: json["district"],
    Categoryy: json["Categoryy"],
    laststatus: json["laststatus"],
    payementready: json["payementready"],
    status: List<String>.from(json["status"].map((x) => x)),
    createdAt: json["createdAt"].toString(),
    updatedAt: json["updatedAt"].toString(),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "ordernumber": ordernumber,
    "username": username,
    "invoicenumber": invoicenumber,
    "product": product,
    "price": price,
    "qnt": qnt,
    "weight": weight,
    "clientname": clientname,
    "phone1": phone1,
    "phone2": phone2,
    "address": address,
    "state": state,
    "district": district,
    "Categoryy": Categoryy,
    "laststatus": laststatus,
    "payementready": payementready,
    "status": List<dynamic>.from(status.map((x) => x)),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };

  static Future<Order?> getOrder(orderNumber) async {
    print(orderNumber);
    print(" ***** orderNumber   ***");
    Network network = Network();
    final Order order;
    var response = await network.getWithHeader("${ApiUtils.getOrder}${orderNumber!}");
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      final result = json.decode(response.body);
      print(result);
      order =Order.fromJson(result[0]);
      order?.price = (order.price * order.qnt) + (order.weight * 50) + order.Categoryy;
      return order;
    }else{
      ToastService.showErrorToast('Something Went Wrong, Please Try Later');
    }
    return null;
  }

  static Future<List<Order?>?> getOrderCategory(category) async {
    print(category);
    print(" ***** category   ***");
    List<Order?> orders = [];
    Network network = Network();
    late Order order;
    var response = await network.getWithHeader("${ApiUtils.getCategory}${category!}");
    print(response.statusCode);
    if(response.statusCode == 200){
      final result = json.decode(response.body);
      print(result);
      print("result");
      List listOrders = result.toList();
      for (var element in listOrders) {
        List listElement = element.toList();
        for (var elem in listElement) {
          print(elem);
          print("element");
          order =Order.fromJson(elem[0]);
          order?.price = (order.price * order.qnt) + (order.weight * 50) + order.Categoryy;
          orders.add(order);
        }
      }
      return orders;
    }else{
      ToastService.showErrorToast('Something Went Wrong, Please Try Later');
    }
    return null;
  }

  static Future<bool> postOrder(data, BuildContext context) async {
    Network network = Network();
    print(data);
    print("********** data *********");
    var response = await network.postWithHeader(ApiUtils.postOrder, data);
    if(response.statusCode == 200){
      ToastService.showSuccessToast("Est fait");
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true);
      return true;
    }else{
      print(response.body);
      ToastService.showErrorToast('Quelque chose s\'est mal passé, veuillez réessayer plus tard');
      return false;
    }
  }
}
