import 'dart:convert';

import '../utils/api_http.dart';
import '../utils/api_utils.dart';
import '../utils/toast.dart';


List<Willaya> StateFromJson(String str) => List<Willaya>.from(json.decode(str).map((x) => Willaya.fromJson(x)));

String StateToJson(List<Willaya> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Willaya {
  Willaya({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt
  });

  String id;
  String name;
  String status;
  String createdAt;
  String updatedAt;

  factory Willaya.fromJson(Map<String, dynamic> json) => Willaya(
    id: json["_id"],
    name: json["name"],
    status: json["status"],
    createdAt: json["createdAt"].toString(),
    updatedAt: json["updatedAt"].toString()
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "status": status,
    "createdAt": createdAt,
    "updatedAt": updatedAt
  };
  static Future<List<Willaya>?> getState() async {

    print(" ***** Category   ***");
    Network network = Network();
    var response = await network.getWithHeader(ApiUtils.states);
    print(response.statusCode);
    List<Willaya> listState = [];
    late Willaya state;
    if(response.statusCode == 200){
      final result = json.decode(response.body);
      print(result);
      List list= result.toList();
      print("result");
      for (var element in list) {
          print(element);
          print("element");
          state =Willaya.fromJson(element);
          listState.add(state);
      }
      return listState;
    }else{
      ToastService.showErrorToast('Something Went Wrong, Please Try Later');
    }
    return null;
  }
}
