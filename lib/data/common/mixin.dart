import 'package:dio/dio.dart';
import 'package:flutter_ali_nike/data/repo/cart_repository.dart';

mixin HttpResponseValidator {
  validateResponse(Response response) {
    if (response.statusCode != 200) {
      ICartRepository.conyChangeNotifier.value = false;
      throw Exception('خطا در دریافت اطلاعات');
    }
  }
}

class SortName {
  static List<String> get sortName {
    return ['جدید ترین', "پربازدید ترین", "قیمت نزولی", "قیمت صعودی"];
  }
}
