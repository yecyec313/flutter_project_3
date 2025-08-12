part of 'shipping_bloc.dart';

class ShippingEvent extends Equatable {
  const ShippingEvent();

  @override
  List<Object> get props => [];
}

// ignore: camel_case_types
class shippingPaymentClicked extends ShippingEvent {
  final DataShipping dataShipping;

  const shippingPaymentClicked(this.dataShipping);
  @override
  List<Object> get props => [dataShipping];
}
