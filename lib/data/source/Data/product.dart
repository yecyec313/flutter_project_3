import 'package:hive_flutter/hive_flutter.dart';
part 'product.g.dart';

@HiveType(typeId: 0)
class ProductData extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final int price;
  @HiveField(4)
  final int discount;
  @HiveField(5)
  final int previousPrice;
  ProductData(this.id, this.title, this.imageUrl, this.price, this.discount,
      this.previousPrice);
  ProductData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        imageUrl = json['image'],
        price = json['previous_price'] == null
            ? json['price'] - json['discount']
            : json['price'],
        previousPrice = json['previous_price'] ?? json['price']
        // + json['discount']
        ,
        discount = json['discount'];
}
