import 'package:dio/dio.dart';
import 'package:flutter_ali_nike/data/source/Data/product.dart';

abstract class DataSource {
  Future<List<ProductData>> getAll(int sort);
  Future<List<ProductData>> Search(String searchTerm);
}

class ProductRemote implements DataSource {
  final Dio httpClient;

  ProductRemote(this.httpClient);
  @override
  // ignore: non_constant_identifier_names
  Future<List<ProductData>> Search(String searchTerm) async {
    final response = await httpClient.get('product/search?q=$searchTerm');
    validateResponse(response);

    final products = <ProductData>[];
    for (var element in (response.data as List)) {
      products.add(ProductData.fromJson(element));
    }
    return products;
  }

  @override
  Future<List<ProductData>> getAll(int sort) async {
    final response = await httpClient.get('product/list?sort=$sort');
    validateResponse(response);
    final products = <ProductData>[];
    for (var element in (response.data as List)) {
      products.add(ProductData.fromJson(element));
    }
    return products;
  }

  validateResponse(Response response) {
    if (response.statusCode != 200) {
      throw Exception('خطا دریافت اطلاعات');
    }
  }
}
