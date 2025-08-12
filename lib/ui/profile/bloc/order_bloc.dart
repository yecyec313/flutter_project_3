import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';
import 'package:flutter_ali_nike/data/repo/shipping_repository.dart';
import 'package:flutter_ali_nike/data/source/Data/order_data.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final IShippingRepository repository;
  OrderBloc(this.repository) : super(OrderInitial()) {
    on<OrderEvent>((event, emit) async {
      if (event is OrderStarted) {
        try {
          emit(OrderLoading());
          final order = await repository.orderList();
          emit(OrderSuccess(order));
        } catch (e) {
          emit(OrderError(AppException()));
        }
      }
    });
  }
}
