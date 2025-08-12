part of 'cart_bloc.dart';

class CartState {
  const CartState();
}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final CartResponseGet carts;

  const CartSuccess({required this.carts});
  // @override
  // List<Object> get props => [carts];
}

class CartError extends CartState {
  final AppException exception;
  // @override
  // List<Object> get props => [exception];
  const CartError(this.exception);
}

class CartAuthRequired extends CartState {}

class CartEmpty extends CartState {}

class CartErrorS extends CartState {
  final AppException exception;
  // @override
  // List<Object> get props => [exception];
  const CartErrorS(this.exception);
}
// sealed class ProductState extends Equatable {
//   const ProductState();

//   @override
//   List<Object> get props => [];
// }

class ProductInitial extends CartState {}

class ProductAddToCartLoading extends CartState {}

class ProductAddToCartSuccess extends CartState {}

class ProductAddToCartError extends CartState {
  final AppException exception;

  const ProductAddToCartError(this.exception);
}
