import 'package:flutter/foundation.dart';
import 'package:flutter_ali_nike/data/source/Data/product.dart';
import 'package:hive_flutter/hive_flutter.dart';

final favoriteManagger = HiveManagger();

class HiveManagger {
  static const _boxName = 'favorite';
  final _box = Hive.box<ProductData>(_boxName);

  // ignore: non_constant_identifier_names
  ValueListenable<Box<ProductData>> get Listenable =>
      Hive.box<ProductData>(_boxName).listenable();
  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductDataAdapter());
    Hive.openBox<ProductData>(_boxName);
  }

  void addFavorite(ProductData product) {
    _box.put(product.id, product);
  }

  void delete(ProductData product) {
    _box.delete(product.id);
  }

  List<ProductData> get favorites => _box.values.toList();

  bool isFavorite(ProductData product) {
    return _box.containsKey(product.id);
  }
}
