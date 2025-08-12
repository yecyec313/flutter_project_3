part of 'delete_bloc.dart';

class DeleteEvent extends Equatable {
  const DeleteEvent();

  @override
  List<Object> get props => [];
}

class Delete extends DeleteEvent {
  final int cartItemsId;

  const Delete(this.cartItemsId);
}
