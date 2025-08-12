import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';

import 'package:flutter_ali_nike/data/repo/cart_repository.dart';
import 'package:flutter_ali_nike/data/source/Data/authinfo.dart';
import 'package:flutter_ali_nike/data/source/Data/cart_data.dart';

part 'cart_event.dart';
part 'cart_state.dart';

var as1;
List<CartItemData>? as2;

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;
  CartBloc(
    this.cartRepository,
  ) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        if (event.authData == null || event.authData!.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await badane(emit, event.isRefresh);
        }
      } else if (event is CartAuthDataChanged) {
        if (event.authData == null || event.authData!.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await badane(emit, false);
          }
        }
      } else if (event is CartDeleteButton) {
        try {
          if (state is CartSuccess) {
            final stateA = (state as CartSuccess);
            var as1 = ICartRepository.conChangeNotifier.value
                .indexWhere((element) => element.id == event.cartItemsId);
            // as2 = stateA.carts.cart_items;
            ICartRepository.conChangeNotifier.value[as1].load = true;
            emit(CartSuccess(carts: stateA.carts));

            // emit(CartSuccess(carts: stateA.carts));
            await Future.delayed(Duration(milliseconds: 1000));
            await cartRepository.delete(event.cartItemsId);
          }

          final aw = await cartRepository.getAll();
          await cartRepository.count();
          if (aw.cart_items.isNotEmpty) {
            StringA = 'A1';
          } else {
            StringA = 'A3';
          }
          if (aw.cart_items.isNotEmpty) {
            ICartRepository.conyChangeNotifier.value = true;
          } else {
            ICartRepository.conyChangeNotifier.value = false;
          }
          final stateB = (state as CartSuccess);
          emit(CartSuccess(carts: stateB.carts));
          // if (state is CartSuccess) {
          //   final stateB = (state as CartSuccess);
          //   ICartRepository.conChangeNotifier.value
          //       .removeWhere((element) => element.id == event.cartItemsId);
          //   // if (stateB.carts.cart_items.isEmpty) {
          //   //   emit(CartEmpty());
          //   // } else {
          //   //   emit(CartSuccess(carts: stateB.carts));
          //   // }
          // }
        } catch (e) {
          // as2![as1].load = false;
          // StringA = 'A';
          debugPrint(e.toString());
          emit(CartError(AppException()));
        }
      } else if (event is AddToCartIsButtonClick) {
        try {
          emit(ProductAddToCartLoading());
          await Future.delayed(const Duration(seconds: 2));
          await cartRepository.count();
          final res = await cartRepository.getAll();
          // StringA = 'A4';

          emit(ProductAddToCartSuccess());
          if (res.cart_items.isNotEmpty) {
            ICartRepository.conyChangeNotifier.value = true;
          } else {
            ICartRepository.conyChangeNotifier.value = false;
          }
        } catch (e) {
          emit(ProductAddToCartError(AppException()));
          debugPrint(e.toString());
        }
      } else if (event is CartMinusButtonClick ||
          event is CartPlusButtonClick) {
        int cartId = 0;
        if (event is CartMinusButtonClick) {
          cartId = event.CartItemId;
        } else if (event is CartPlusButtonClick) {
          cartId = event.CartItemId;
        }
        try {
          int newCount = 0;
          if (state is CartSuccess) {
            final stateA = (state as CartSuccess);

            var aS = ICartRepository.conChangeNotifier.value
                .indexWhere((element) => element.id == cartId);
            newCount = event is CartMinusButtonClick
                ? --ICartRepository.conChangeNotifier.value[aS].count
                : ++ICartRepository.conChangeNotifier.value[aS].count;
            // emit(CartSuccess(carts: stateA.carts));
            ICartRepository.conChangeNotifier.value[aS].loadCount = true;
            // final res = await cartRepository.getAll();
            emit(CartSuccess(carts: stateA.carts));
          }
          await Future.delayed(Duration(milliseconds: 300));
          await cartRepository.changeCount(cartId, newCount);
          // final stateA = (state as CartSuccess);
          // emit(CartSuccess(carts: stateA.carts));
          // await cartRepository.getAll();
          // await cartRepository.count();
          if (state is CartSuccess) {
            final stateB = (state as CartSuccess);
            ICartRepository.conChangeNotifier.value
                .firstWhere((element) => element.id == cartId)
              ..count = newCount
              ..loadCount = false;
            // final res = await cartRepository.getAll();
            emit(cartInfoNew(stateB.carts));
          }
        } catch (e) {
          debugPrint(e.toString());
          emit(CartError(AppException()));
        }
      }
    });
  }
  CartSuccess cartInfoNew(CartResponseGet cartResponse) {
    int payble = 0;
    int ship = 0;
    int total = 0;
    cartResponse.cart_items.forEach((element) {
      total += element.product.previousPrice * element.count;
      payble += element.product.price * element.count;
    });
    ship = payble >= 250000 ? 0 : 30000;
    cartResponse.payable_price = payble;
    cartResponse.shipping_cost = ship;
    cartResponse.total_price = total;
    return CartSuccess(carts: cartResponse);
  }

  Future<void> badane(Emitter<CartState> emit, bool isRef) async {
    try {
      if (!isRef) {
        emit(CartLoading());
      }

      final resultC = await cartRepository.getAll();

      emit(CartSuccess(carts: resultC));
      if (resultC.cart_items.isNotEmpty) {
        ICartRepository.conyChangeNotifier.value = true;
      } else {
        ICartRepository.conyChangeNotifier.value = false;
      }

      // if (resultC.cart_items.isEmpty) {
      //   emit(CartEmpty());
      // }
      // else {
      //   emit(CartSuccess(carts: resultC));
      // }
    } catch (e) {
      emit(CartError(AppException()));
      debugPrint(e.toString());
    }
  }

  // void startRefresh() {
  //   _timer = Timer.periodic(refreshInterval, (timer) {
  //     add(CartStarted(IAuthRepository.authChangeNotifier.value));
  //   });
  // }

  // void stopRefresh() {
  //   _timer?.cancel();
  // }
}
