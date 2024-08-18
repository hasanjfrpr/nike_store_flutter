import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/data/models/banner.dart';
import 'package:nike_store_flutter/data/models/product.dart';
import 'package:nike_store_flutter/data/repo/banner_repo.dart';
import 'package:nike_store_flutter/data/repo/product_repo.dart';
import 'package:nike_store_flutter/ui/home/home.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository banner;
  final IProductRepository productLatest ;
  final IProductRepository productPopular;
  HomeBloc({required this.banner  ,required this.productLatest , required this.productPopular}) : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async{
      if(event is HomeStarted || event is HomeRefreshing){
        try{
            emit(HomeLoading());
          final bannerR =await banner.getBanners();
          final productLatestR = await productLatest.getAllProducts(ProductSort.latest);
          final  productPopularR= await productPopular.getAllProducts(ProductSort.popular);
          emit(HomeSuccess(banner: bannerR, productLatest: productLatestR, productPopular: productPopularR));


        }catch(e){
          emit(HomeError(exception: e is AppException? e : AppException()));
        }
      }
    });
  }
}
