import 'package:flutter_ali_nike/data/common/http.dart';
import 'package:flutter_ali_nike/data/source/Data/order_data.dart';
import 'package:flutter_ali_nike/data/source/Data/shipping.dart';
import 'package:flutter_ali_nike/data/source/Data_Source/shipping_datasource.dart';

abstract class IShippingRepository extends ShippingDataSource {}

final repositoryShip = ShippingRepository(ShippingRemote(httpClient));

class ShippingRepository implements IShippingRepository {
  final ShippingDataSource dataSource;

  ShippingRepository(this.dataSource);

  @override
  Future<ShippingResult> create(DataShipping data) {
    return dataSource.create(data);
  }

  @override
  Future<CheckOutShipping> checkOut(int orderId) {
    return dataSource.checkOut(orderId);
  }

  @override
  Future<List<OrderData>> orderList() {
    return dataSource.orderList();
  }
}
