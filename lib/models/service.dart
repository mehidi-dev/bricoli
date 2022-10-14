import 'dart:convert';

import '../utils/api_http.dart';
import '../utils/api_utils.dart';
import '../utils/toast.dart';


List<Service> ServiceFromJson(String str) => List<Service>.from(json.decode(str).map((x) => Service.fromJson(x)));

String ServiceToJson(List<Service> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Service {
  Service({
    required this.id,
    required this.name,
    required this.status,
    required this.price,
    required this.category,
    required this.img,
    required this.createdAt,
    required this.updatedAt
  });

  String id;
  String name;
  String status;
  String price;
  String category;
  String img;
  String createdAt;
  String updatedAt;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["_id"],
    name: json["name"],
    status: json["status"],
    price: json["price"].toString(),
    category: json["category"],
      img: json["img"],
    createdAt: json["createdAt"].toString(),
    updatedAt: json["updatedAt"].toString()
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "status": status,
    "price": price,
    "category": category,
    "img": img,
    "createdAt": createdAt,
    "updatedAt": updatedAt
  };
  static Future<List<Service>?> getService() async {
    Network network = Network();
    var response = await network.getWithHeader(ApiUtils.getService);
    List<Service> listService = [];
    late Service service;
    if(response.statusCode == 200){
      final result = json.decode(response.body);
      List list= result.toList();
      for (var element in list) {
          print(element);
          print("element");
          service =Service.fromJson(element);
          listService.add(service);
      }
      return listService;
    }else{
      ToastService.showErrorToast('Something Went Wrong, Please Try Later');
    }
    return null;
  }
}
