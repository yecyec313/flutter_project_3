part of 'insert_bloc.dart';

sealed class InsertEvent extends Equatable {
  const InsertEvent();

  @override
  List<Object> get props => [];
}

class SaveInsertClicked extends InsertEvent {
  final String title;
  final String content;

  const SaveInsertClicked(this.title, this.content);
}
