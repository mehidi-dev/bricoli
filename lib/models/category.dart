import 'dart:convert';

import 'Package:Bricoli_Dari/models/service.dart';

import '../utils/api_http.dart';
import '../utils/api_utils.dart';
import '../utils/toast.dart';


List<Category> CategoryFromJson(String str) => List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String CategoryToJson(List<Category> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  Category({
    required this.id,
    required this.name,
    required this.status,
    required this.color,
    required this.img,
    required this.colortext,
    required this.createdAt,
    required this.updatedAt,
    required this.services
  });

  String id;
  String name;
  String status;
  String color;
  String img;
  String colortext;
  String createdAt;
  String updatedAt;
  List<Service?> services;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["_id"],
    name: json["name"] ?? "",
    status: json["status"],
      color: json["color"],
      img: json["img"],
      colortext: json["colortext"],
     createdAt: json["createdAt"].toString(),
     updatedAt: json["updatedAt"].toString(),
      services: json["services"] ?? [],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "img": img,
    "color": color,
    "status": status,
    "colortext": colortext,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "services": services
  };
  static Future<List<Category>?> getCategory() async {

    print(" ***** Category   ***");
    Network network = Network();
    var response = await network.getWithHeader(ApiUtils.getCategory);
    print(response.statusCode);
    List<Category> listCategory = [];
    late Category category;
    if(response.statusCode == 200){
      final result = json.decode(response.body);
      print(result);
      List list= result.toList();
      print("result");
      for (var element in list) {
          print(element);
          print("element");
          category =Category.fromJson(element);
          listCategory.add(category);
      }
      return listCategory;
    }else{
      ToastService.showErrorToast('Something Went Wrong, Please Try Later');
    }
    return null;
  }

  static Future<List<Service>?> getService(String id) async {
    Network network = Network();
    var response = await network.getWithHeader(ApiUtils.serviceByCategory + id,);
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
