import 'dart:convert';
import 'Package:Bricoli_Dari/utils/toast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  http.Response? response;

  String? token;

  static String host = 'https://api.bricolidari.com/api/';
  // ignore: prefer_final_fields
  int _timeoutDuration = 60;

  _setHeadersWithToken() {
    return SharedPreferences.getInstance().then((storage) {
      token = storage.getString('token');
      print(token);
      print("*****  token  ******");
      return {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token ?? ''}'
      };
    });
  }

  _setHeaders() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};

  Future<http.Response> postWithHeader(apiUrl, data) async {
    var fullUrl = host + apiUrl;
    Uri uri  = Uri.parse(fullUrl);
    final response = await http
        .post(uri,
        body: jsonEncode(data), headers: await _setHeadersWithToken())
        .timeout(
      Duration(seconds: _timeoutDuration),
      onTimeout: () async => await ToastService.showErrorToast('Please Check Your Internet Connection'),
    );
    return response;
  }

  Future<http.Response> post(apiUrl, data) async {
    var fullUrl = host  + apiUrl;
    Uri uri  = Uri.parse(fullUrl);
    final response = await http
        .post(uri, body: jsonEncode(data), headers: _setHeaders())
        .timeout(
      Duration(seconds: _timeoutDuration),
      onTimeout: () async => await ToastService.showErrorToast('Please Check Your Internet Connection'),
    );
    return response;
  }

  Future<http.Response> getWithHeader(apiUrl) async {
    var fullUrl = host  + apiUrl;
    print(fullUrl);
    print("*****  fullUrl  ******");
    Uri uri  = Uri.parse(fullUrl);
    final http.Response response =
    await http.get(uri, headers: await _setHeadersWithToken()).timeout(
      Duration(seconds: _timeoutDuration),
      onTimeout: () async => await ToastService.showErrorToast('Please Check Your Internet Connection'),
    );
    return response;
  }

  Future<http.Response> get(apiUrl) async {
    var fullUrl = host  + apiUrl;
    Uri uri  = Uri.parse(fullUrl);
    final response = await http.get(uri, headers: _setHeaders()).timeout(
      Duration(seconds: _timeoutDuration),
      onTimeout: () async => await ToastService.showErrorToast('Please Check Your Internet Connection'),
    );
    return response;
  }
}
