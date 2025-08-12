part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthIsButtomClick extends AuthEvent {
  final String username;
  final String password;

  const AuthIsButtomClick(this.username, this.password);
}

class AuthIsloginModeChange extends AuthEvent {}
