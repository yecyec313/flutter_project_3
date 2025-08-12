import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';
import 'package:flutter_ali_nike/data/repo/shipping_repository.dart';
import 'package:flutter_ali_nike/data/source/Data/shipping.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final IShippingRepository repository;
  PaymentBloc(this.repository) : super(PaymentLoading()) {
    on<PaymentEvent>((event, emit) async {
      if (event is PaymentStarted) {
        try {
          emit(PaymentLoading());
          final check = await repository.checkOut(event.orderId);
          emit(PaymentSuccess(check));
        } catch (e) {
          emit(PaymentError(AppException()));
        }
      }
    });
  }
}
