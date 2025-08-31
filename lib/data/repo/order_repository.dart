import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/order.dart';
import 'package:nike_ecommerce_flutter/data/payment_receipt.dart';
import 'package:nike_ecommerce_flutter/data/source/order_data_source.dart';

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource orderDataSource;

  const OrderRepository(this.orderDataSource);
  @override
  Future<SubmitOrderResult> submitOrder(SubmitOrderParams params) =>
      orderDataSource.submitOrder(params);

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) =>
      orderDataSource.getPaymentReceipt(orderId);

  @override
  Future<List<OrderEntity>> getOrders() {
    return orderDataSource.getOrders();
  }
}
