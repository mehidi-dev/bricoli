import 'package:bricoli_app/models/DBHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_model.dart';

class CartProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  int _counter = 0;
  int _numberHours = 1;
  int get counter => _counter;
  int get numberHours => _numberHours;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  List<Cart> cart = [];

  Future<List<Cart>> getData() async {
    cart = await dbHelper.getCartList();
    notifyListeners();
    return cart;
  }

  void _setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_items', _counter);
    prefs.setInt('item_numberHours', _numberHours);
    notifyListeners();
  }

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_items') ?? 0;
    _numberHours = prefs.getInt('item_numberHours') ?? 1;
  }

  void addCounter() {
    _counter++;
    _setPrefsItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefsItems();
    notifyListeners();
  }
  void initCounter() {
    _counter = 0;
    _setPrefsItems();
    notifyListeners();
  }
  int getCounter() {
    _getPrefsItems();
    return _counter;
  }



  void removeItem(String id) {
    final index = cart.indexWhere((element) => element.serviceId == id);
    cart.removeAt(index);
    _setPrefsItems();
    notifyListeners();
  }

  int getNumberHours(int quantity) {
    _getPrefsItems();
    return _numberHours;
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefsItems();
    return _totalPrice;
  }
}