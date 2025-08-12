part of 'home_bloc_bloc.dart';

class HomeBlocState extends Equatable {
  const HomeBlocState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeBlocState {}

class HomeSuccess extends HomeBlocState {
  final List<ProductData> productLeates;
  final List<ProductData> productPupolar;
  final List<BannerData> banners;

  const HomeSuccess(
      {required this.productLeates,
      required this.productPupolar,
      required this.banners});
  @override
  List<Object> get props => [productLeates, productPupolar, banners];
}

class HomeError extends HomeBlocState {
  final AppException exception;

  const HomeError({required this.exception});
  @override
  List<Object> get props => [exception];
}
