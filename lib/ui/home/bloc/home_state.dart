part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
 
}

class HomeError extends HomeState{
final AppException exception;

  const HomeError({required this.exception});

@override
  List<Object> get props => [exception];

}

class HomeSuccess extends HomeState{
 final List<BannerEntity> banner;
  final List<ProductEntity> productLatest;
  final List<ProductEntity> productPopular;

  const HomeSuccess({required this.banner,required this.productLatest,required this.productPopular});

}
