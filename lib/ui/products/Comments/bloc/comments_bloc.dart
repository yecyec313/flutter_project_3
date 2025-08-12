import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';
import 'package:flutter_ali_nike/data/repo/repository_comment.dart';
import 'package:flutter_ali_nike/data/source/Data/comments.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentsRepository repository;
  final int id;
  CommentsBloc(this.repository, this.id) : super(CommentsLoading()) {
    on<CommentsEvent>((event, emit) async {
      if (event is CommentStarted) {
        emit(CommentsLoading());
        try {
          final rC = await repository.getAll(id: id);
          emit(CommentsSuccess(comments: rC));
        } catch (e) {
          emit(CommentsError(exception: AppException()));
          debugPrint(e.toString());
        }
      }
    });
  }
}
