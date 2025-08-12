import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/data/common/http.dart';
import 'package:flutter_ali_nike/data/source/Data/cart_data.dart';
import 'package:flutter_ali_nike/data/source/Data/cart_response.dart';
import 'package:flutter_ali_nike/data/source/Data_Source/cartadd_datasource.dart';

abstract class CartRepository extends CartDataSource {}

final repositoryCart = ICartRepository(CartRemote(httpClient));

class ICartRepository implements CartRepository {
  final CartDataSource dataSource;
  static ValueNotifier<int> countChangeNotifier = ValueNotifier(0);
  static ValueNotifier<List<CartItemData>> conChangeNotifier =
      ValueNotifier([]);
  static ValueNotifier<bool> conyChangeNotifier = ValueNotifier(false);
  ICartRepository(this.dataSource);
  @override
  Future<CartResponsePost> add(int productId) {
    return dataSource.add(productId);
  }

  @override
  Future<CartResponsePost> changeCount(int cartItemId, int count) {
    return dataSource.changeCount(cartItemId, count);
  }

  @override
  Future<int> count() async {
    final count = await dataSource.count();
    countChangeNotifier.value = count;
    return count;
  }

  @override
  Future<void> delete(int cartItemId) {
    return dataSource.delete(cartItemId);
  }

  @override
  Future<CartResponseGet> getAll() async {
    final alo = await dataSource.getAll();

    List<CartItemData> ops = [];
    for (var element in alo.cart_items) {
      ops.add(element);
    }

    conChangeNotifier.value = ops;

    return alo;
  }

  // Future<void> _persistsAuthToken(CartResponseGet authData) async {
  //   loadAuthInfo(authData);
  // }

  // Future<void> loadAuthInfo(CartResponseGet authData) async {
  //   // final SharedPreferences sharedPreferences =
  //   //     await SharedPreferences.getInstance();
  //   // final access = sharedPreferences.getString("cart_items") ?? '';

  //   var t = authData;

  //   authChangeNotifier.value = t.cart_items;
  // }
  // Future<void> _persistsAuthToken(CartResponseGet carts) async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   final cartData = carts.cart_items;
  //   await sharedPreferences.setmap('cart_item_id', cartData);
  //   loadAuthInfo();
  // }

  // Future<void> loadAuthInfo() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   final String accessToken =
  //       sharedPreferences.getString("access_token") ?? '';

  //   final String refreshToken =
  //       sharedPreferences.getString("refresh_token") ?? '';
  // }
}
