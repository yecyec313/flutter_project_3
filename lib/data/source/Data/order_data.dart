import 'package:flutter_ali_nike/data/source/Data/product.dart';

class OrderData {
  final int id;
  final int payable;
  // ignore: non_constant_identifier_names
  final List<ProductData> order;

  OrderData(this.id, this.payable, this.order);
  OrderData.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        payable = json["payable"],
        order = (json["order_items"] as List)
            .map((element) => ProductData.fromJson(element["product"]))
            .toList();
}
