// ignore_for_file: non_constant_identifier_names

import 'package:flutter_ali_nike/data/common/http.dart';
import 'package:flutter_ali_nike/data/source/Data/product.dart';
import 'package:flutter_ali_nike/data/source/Data_Source/product_datasource.dart';

final repositoryP = IRepositoryProduct(ProductRemote(httpClient));

abstract class RepositoryProduct {
  Future<List<ProductData>> getAll(int sort);
  // ignore: duplicate_ignore
  // ignore: non_constant_identifier_names
  Future<List<ProductData>> Search(String searchTerm);
}

class IRepositoryProduct implements RepositoryProduct {
  final DataSource dataSource;

  IRepositoryProduct(this.dataSource);

  @override
  Future<List<ProductData>> Search(String searchTerm) {
    return dataSource.Search(searchTerm);
  }

  @override
  Future<List<ProductData>> getAll(int sort) {
    return dataSource.getAll(sort);
  }
}
