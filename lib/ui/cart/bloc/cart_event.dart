// ignore_for_file: non_constant_identifier_names

part of 'cart_bloc.dart';

class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class CartStarted extends CartEvent {
  final AuthData? authData;
  final bool isRefresh;
  @override
  const CartStarted(this.authData, {this.isRefresh = false});
}

class CartDeleteButton extends CartEvent {
  final int cartItemsId;

  const CartDeleteButton(this.cartItemsId);
  @override
  List<Object?> get props => [cartItemsId];
}

class CartAuthDataChanged extends CartEvent {
  final AuthData? authData;

  const CartAuthDataChanged(this.authData);
}

class CartMinusButtonClick extends CartEvent {
  final int CartItemId;
  const CartMinusButtonClick(this.CartItemId);
  @override
  List<Object?> get props => [CartItemId];
}

class CartPlusButtonClick extends CartEvent {
  final int CartItemId;
  const CartPlusButtonClick(this.CartItemId);
  @override
  List<Object?> get props => [CartItemId];
}
// sealed class ProductEvent extends Equatable {
//   const ProductEvent();

//   @override
//   List<Object> get props => [];
// }

class AddToCartStarted extends CartEvent {}

class AddToCartIsButtonClick extends CartEvent {
  final int productId;

  const AddToCartIsButtonClick({required this.productId});
}
