part of 'comments_bloc.dart';

class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object> get props => [];
}

class CommentsLoading extends CommentsState {}

class CommentsSuccess extends CommentsState {
  final List<CommentData> comments;

  const CommentsSuccess({required this.comments});
  @override
  List<Object> get props => [comments];
}

class CommentsError extends CommentsState {
  final AppException exception;

  const CommentsError({required this.exception});
  @override
  List<Object> get props => [exception];
}
