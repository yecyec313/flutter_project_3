part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState(this.isLoginMode);
  final bool isLoginMode;
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial(super.isLoginMode);
  @override
  List<Object> get props => [isLoginMode];
}

class AuthSuccess extends AuthState {
  const AuthSuccess(super.isLoginMode);
  @override
  List<Object> get props => [isLoginMode];
}

class AuthLoading extends AuthState {
  const AuthLoading(super.isLoginMode);
  @override
  List<Object> get props => [isLoginMode];
}

class AuthError extends AuthState {
  const AuthError(super.isLoginMode, this.exception);
  final AppException exception;
  @override
  List<Object> get props => [exception, isLoginMode];
}
