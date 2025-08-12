part of 'product_list_bloc.dart';

class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object> get props => [];
}

class ProductListLoading extends ProductListState {}

class ProductListSuccess extends ProductListState {
  final int sort;
  final List<ProductData> proD;

  const ProductListSuccess(this.sort, this.proD);
  @override
  // TODO: implement props
  List<Object> get props => [sort, proD];
}

class ProductError extends ProductListState {
  final AppException exception;
  @override
  // TODO: implement props
  List<Object> get props => [exception];
  const ProductError(this.exception);
}

class ProductEmpty extends ProductListState {
  final String text1;

  const ProductEmpty(this.text1);
  @override
  // TODO: implement props
  List<Object> get props => [text1];
}
