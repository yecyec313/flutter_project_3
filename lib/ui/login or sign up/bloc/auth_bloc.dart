import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';
import 'package:flutter_ali_nike/data/repo/auth_repository.dart';
import 'package:flutter_ali_nike/data/repo/cart_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ICartRepository cartRepository;
  final AuthRepository authRepository;
  bool isLoginMode;
  AuthBloc(this.authRepository, this.cartRepository, {this.isLoginMode = true})
      : super(AuthInitial(isLoginMode)) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthIsButtomClick) {
          emit(AuthLoading(isLoginMode));

          if (isLoginMode) {
            await authRepository.login(event.username, event.password);
            await cartRepository.count();
            await cartRepository.getAll();

            emit(AuthSuccess(isLoginMode));
          } else {
            await authRepository.signUp(event.username, event.password);

            emit(AuthSuccess(isLoginMode));
          }
        } else if (event is AuthIsloginModeChange) {
          isLoginMode = !isLoginMode;

          emit(AuthInitial(isLoginMode));
        }

        isLoginMode
            ? StringA = "اطلاعات کاربر صحیح نیست"
            : StringA = "کاربر قبلا ثبت نام کرده";
      } catch (e) {
        // if (e.toString() ==
        //     'In order to resolve this exception you typically have either to verify and fix your request code or you have to fix the server code.') {
        //   emit(AuthError(isLoginMode, AppException(message: StringA)));
        // }
        emit(AuthError(isLoginMode, AppException(message: StringA)));
        debugPrint(e.toString());
      }
      // } catch (e) {
      //   emit(AuthError(isLoginMode, AppException()));
      // }
    });
  }
}
