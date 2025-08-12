part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final CheckOutShipping checkOutShipping;

  const PaymentSuccess(this.checkOutShipping);
  @override
  // TODO: implement props
  List<Object> get props => [checkOutShipping];
}

class PaymentError extends PaymentState {
  final AppException exception;

  const PaymentError(this.exception);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
}
