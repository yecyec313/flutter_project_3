part of 'insert_bloc.dart';

sealed class InsertState extends Equatable {
  const InsertState();

  @override
  List<Object> get props => [];
}

class InsertInitial extends InsertState {}

class InsertLoading extends InsertState {}

class InsertSuccess extends InsertState {
  final CommentData comment;
  final String massage;

  const InsertSuccess(this.comment, this.massage);
}

class InsertError extends InsertState {
  final AppException exception;

  const InsertError(this.exception);
  @override
  List<Object> get props => [exception];
}
