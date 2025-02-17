import 'dart:convert'; // Add this import for jsonEncode/jsonDecode

import 'package:shared_preferences/shared_preferences.dart';

import '../models/diamond_model.dart';

class LocalStorage {
  static const _cartKey = 'cart';

  static Future<void> saveCart(List<Diamond> cart) async {
    final prefs = await SharedPreferences.getInstance();

    final cartJson =
        cart.map((diamond) => jsonEncode(diamond.toJson())).toList();
    await prefs.setStringList(_cartKey, cartJson);
  }

  static Future<List<Diamond>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList(_cartKey) ?? [];

    return cartJson
        .map((jsonString) => Diamond.fromJson(jsonDecode(jsonString)))
        .toList();
  }
}
