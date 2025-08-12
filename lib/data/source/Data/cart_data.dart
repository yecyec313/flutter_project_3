import 'package:flutter_ali_nike/data/source/Data/product.dart';

class CartItemData {
  final ProductData product;
  final int id;
  int count;
  bool load;
  bool loadCount;

  CartItemData.fromJson(Map<String, dynamic> json)
      : product = ProductData.fromJson(json['product']),
        loadCount = false,
        load = false,
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemData> parsJson(List<dynamic> jsonArrey) {
    final List<CartItemData> cartItems = [];
    // ignore: avoid_function_literals_in_foreach_calls
    jsonArrey.forEach((element) {
      cartItems.add(CartItemData.fromJson(element));
    });
    return cartItems;
  }
}

class CartResponseGet {
  List<CartItemData> cart_items;
  int payable_price;
  int total_price;
  int shipping_cost;

  CartResponseGet.fromJson(Map<String, dynamic> json)
      : cart_items = CartItemData.parsJson(json['cart_items']),
        payable_price = json['payable_price'],
        total_price = json['total_price'],
        shipping_cost = json['shipping_cost'];
}
