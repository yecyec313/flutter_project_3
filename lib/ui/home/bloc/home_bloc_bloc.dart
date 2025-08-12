import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';
import 'package:flutter_ali_nike/data/repo/repository.dart';
import 'package:flutter_ali_nike/data/repo/repositoryBanner.dart';
import 'package:flutter_ali_nike/data/source/Data/banner.dart';
import 'package:flutter_ali_nike/data/source/Data/product.dart';

part 'home_bloc_event.dart';
part 'home_bloc_state.dart';

class HomeBlocBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
  final RepositoryBanner banners;
  final RepositoryProduct products;
  HomeBlocBloc(this.banners, this.products) : super(HomeLoading()) {
    on<HomeBlocEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        try {
          emit(HomeLoading());
          final pl = await products.getAll(0);
          final pp = await products.getAll(1);
          final b = await banners.getAll();
          emit(HomeSuccess(productLeates: pl, productPupolar: pp, banners: b));
        } catch (e) {
          emit(HomeError(exception: e is AppException ? e : AppException()));
          debugPrint(e.toString());
        }
      }
    });
  }
}
