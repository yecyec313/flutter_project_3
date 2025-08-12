part of 'product_list_bloc.dart';

class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object> get props => [];
}

class ProductStarted extends ProductListEvent {
  final int sort;
  final String searchTerm;
  const ProductStarted(this.sort, this.searchTerm);
  @override
  // TODO: implement props
  List<Object> get props => [sort, searchTerm];
}
