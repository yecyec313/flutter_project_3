import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';
import 'package:flutter_ali_nike/data/repo/repository.dart';
import 'package:flutter_ali_nike/data/source/Data/product.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final RepositoryProduct repository;
  ProductListBloc(this.repository) : super(ProductListLoading()) {
    on<ProductListEvent>((event, emit) async {
      if (event is ProductStarted) {
        emit(ProductListLoading());
        try {
          final product = event.searchTerm.isEmpty
              ? await repository.getAll(event.sort)
              : await repository.Search(event.searchTerm);
          if (product.isNotEmpty) {
            emit(ProductListSuccess(event.sort, product));
          } else {
            emit(const ProductEmpty(
                "محصولی مشابه عبارت مورد نظر جستجو یافت نشد"));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }
}
