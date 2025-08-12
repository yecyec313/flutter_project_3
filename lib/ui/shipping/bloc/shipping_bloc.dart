import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';
import 'package:flutter_ali_nike/data/repo/shipping_repository.dart';
import 'package:flutter_ali_nike/data/source/Data/shipping.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IShippingRepository shippingRepository;
  ShippingBloc(this.shippingRepository) : super(ShippingInitial()) {
    on<ShippingEvent>((event, emit) async {
      if (event is shippingPaymentClicked) {
        try {
          emit(ShippingLoading());
          final result = await shippingRepository.create(event.dataShipping);
          emit(ShippingSuccess(result));
        } catch (e) {
          emit(ShippingError(AppException()));
        }
      }
    });
  }
}
