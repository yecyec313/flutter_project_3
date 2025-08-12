import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';
import 'package:flutter_ali_nike/data/repo/cart_repository.dart';
import 'package:flutter_ali_nike/data/source/Data/cart_data.dart';

part 'delete_event.dart';
part 'delete_state.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  final CartRepository cartRepository;
  DeleteBloc(this.cartRepository) : super(DeleteInitial()) {
    on<DeleteEvent>((event, emit) async {
      if (event is Delete) {
        try {
          // final stateA = (state as CartSuccessS);
          // var aS = state1?.carts.cart_items
          //     .indexWhere((element) => element.id == event.cartItemsId);
          // // emit(CartSuccess(carts: stateA.carts));
          // state1?.carts.cart_items[aS!].load = true;

          emit(CartLoad());

          await Future.delayed(const Duration(milliseconds: 2000));
          await cartRepository.delete(event.cartItemsId);

          // final state1 = (state as CartSuccessS);
          state1?.carts.cart_items
              .removeWhere((element) => element.id == event.cartItemsId);

          // if (stateB.carts.cart_items.isEmpty) {
          //   emit(CartEmpty());
          // } else {
          emit(CartSuccessS(carts: state1!.carts));
          // }
        } catch (e) {
          debugPrint(e.toString());

          // emit(CartSuccess(carts: stateA.carts));

          emit(Error(AppException()));
        }
      }
    });
  }
}
