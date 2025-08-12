import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';
import 'package:flutter_ali_nike/data/repo/auth_repository.dart';
import 'package:flutter_ali_nike/data/repo/repository_comment.dart';
import 'package:flutter_ali_nike/data/source/Data/comments.dart';

part 'insert_event.dart';
part 'insert_state.dart';

class InsertBloc extends Bloc<InsertEvent, InsertState> {
  final int productId;
  final CommentsRepository repository;
  InsertBloc(this.repository, this.productId) : super(InsertInitial()) {
    on<InsertEvent>((event, emit) async {
      if (event is SaveInsertClicked) {
        emit(InsertLoading());
        await Future.delayed(Duration(milliseconds: 300));
        try {
          if (event.title.isNotEmpty && event.content.isNotEmpty) {
            if (IAuthRepository.isAuthI()) {
              final insert = await repository.insert(
                  event.title, event.content, productId);
              emit(InsertSuccess(insert,
                  "نظر شما با موفقیت ثبت شد و پس از تایید منتشر می شود"));
            } else {
              emit(InsertError(
                  AppException(message: "شما به حساب خود وارد نشده اید")));
            }
          } else {
            emit(InsertError(
                AppException(message: "عنوان و متن نظر خود را وارد کنید")));
          }
        } catch (e) {
          emit(InsertError(AppException()));
        }
      }
    });
  }
}
