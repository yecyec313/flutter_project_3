part of 'delete_bloc.dart';

class DeleteState {
  const DeleteState();
}

class DeleteInitial extends DeleteState {}

class Error extends DeleteState {
  final AppException exception;
  // @override
  // List<Object> get props => [exception];
  const Error(this.exception);
}

class CartSuccessS extends DeleteState {
  final CartResponseGet carts;

  const CartSuccessS({required this.carts});
  // @override
  // List<Object> get props => [carts];
}

class CartLoad extends DeleteState {}
