part of 'home_bloc_bloc.dart';

class HomeBlocEvent extends Equatable {
  const HomeBlocEvent();

  @override
  List<Object> get props => [];
}

class HomeStarted extends HomeBlocEvent {}

class HomeRefresh extends HomeBlocEvent {}
