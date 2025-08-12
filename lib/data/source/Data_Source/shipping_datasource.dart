import 'package:dio/dio.dart';
import 'package:flutter_ali_nike/data/common/mixin.dart';
import 'package:flutter_ali_nike/data/source/Data/order_data.dart';
import 'package:flutter_ali_nike/data/source/Data/shipping.dart';

abstract class ShippingDataSource {
  Future<ShippingResult> create(DataShipping data);
  Future<CheckOutShipping> checkOut(int orderId);
  Future<List<OrderData>> orderList();
}

class ShippingRemote with HttpResponseValidator implements ShippingDataSource {
  final Dio httpClient;

  ShippingRemote(this.httpClient);
  @override
  Future<ShippingResult> create(DataShipping data) async {
    final response = await httpClient.post('order/submit', data: {
      "first_name": data.firstName,
      "last_name": data.last,
      "postal_code": data.post,
      "mobile": data.mob,
      "address": data.adress,
      "payment_method":
          data.par == nupardakht.mahaly ? "cash_on_delivery" : 'online'
    });
    validateResponse(response);
    return ShippingResult.fromJson(response.data);
  }

  @override
  Future<CheckOutShipping> checkOut(int orderId) async {
    final response = await httpClient.get('order/checkout?order_id=$orderId');
    validateResponse(response);
    return CheckOutShipping.fromJson(response.data);
  }

  @override
  Future<List<OrderData>> orderList() async {
    final response = await httpClient.get("order/list");
    validateResponse(response);
    return (response.data as List).map((e) => OrderData.fromJson(e)).toList();
  }
}
