part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final List<OrderData> orderData;

  const OrderSuccess(this.orderData);
  @override
  List<Object> get props => [orderData];
}

class OrderError extends OrderState {
  final AppException exception;

  const OrderError(this.exception);
  @override
  List<Object> get props => [exception];
}
