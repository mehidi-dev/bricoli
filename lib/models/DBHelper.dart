import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'cart_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart(id INTEGER PRIMARY KEY AUTOINCREMENT, serviceId VARCHAR UNIQUE, name TEXT, price VARCHAR, category VARCHAR, numberHours INTEGER, status TEXT, img TEXT)');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await database;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    var dbClient = await database;
    print(dbClient!.isOpen);
    print(dbClient!.path);
    final List<Map<String, Object?>> queryResult =  await dbClient.query('cart');
    return queryResult.map((result) => Cart.fromMap(result)).toList();
  }

  Future<int> deleteCartItem(String id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'serviceId = ?', whereArgs: [id]);
  }
  Future<int> deleteCart() async {
    var dbClient = await database;
    return await dbClient!.delete('cart');
  }



  Future<List<Cart>> getCartId(int id) async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryIdResult =
    await dbClient!.query('cart', where: 'serviceId = ?', whereArgs: [id]);
    return queryIdResult.map((e) => Cart.fromMap(e)).toList();
  }
}