import 'package:dio/dio.dart';

import 'package:flutter_ali_nike/data/common/mixin.dart';
import 'package:flutter_ali_nike/data/source/Data/cart_data.dart';
import 'package:flutter_ali_nike/data/source/Data/cart_response.dart';

abstract class CartDataSource {
  Future<CartResponsePost> add(int productId);
  Future<CartResponsePost> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartResponseGet> getAll();
}

class CartRemote with HttpResponseValidator implements CartDataSource {
  final Dio httpClient;

  CartRemote(this.httpClient);

  @override
  Future<CartResponsePost> add(int productId) async {
    final response =
        await httpClient.post('cart/add', data: {"product_id": productId});
    validateResponse(response);
    return CartResponsePost.fromJson(response.data);
  }

  @override
  Future<CartResponseGet> getAll() async {
    final response = await httpClient.get('cart/list');

    validateResponse(response);

    return CartResponseGet.fromJson(response.data);
  }

  @override
  Future<CartResponsePost> changeCount(int cartItemId, int count) async {
    final response = await httpClient.post('cart/changeCount',
        data: {"cart_item_id": cartItemId, "count": count});
    validateResponse(response);
    return CartResponsePost.fromJson(response.data);
  }

  @override
  Future<int> count() async {
    final response = await httpClient.get('cart/count');
    validateResponse(response);
    return response.data['count'];
  }

  @override
  Future<void> delete(int cartItemId) async {
    final response = await httpClient
        .post('cart/remove', data: {"cart_item_id": cartItemId});
    validateResponse(response);
  }
  // Future<void> loadAuthInfo() async {

  //   if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
  //     authChangeNotifier.value = AuthData(accessToken, refreshToken);
  //   } else {}
  // }
}
