import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/data/models/product.dart';
import 'package:nike_store_flutter/data/repo/product_repo.dart';
import 'package:nike_store_flutter/ui/home/home.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IProductRepository productRepo;
  ProductListBloc(this.productRepo) : super(LoadingProductListState()) {
    on<ProductListEvent>((event, emit) async{
      if(event is StartProductListEvent){
        emit(StartedFirstTimeProductListState()); 
      }else if(event is SortProductListEvent){
        try{
          emit(LoadingProductListState());
        final productList = await productRepo.getAllProducts(event.sort);
        emit(SuccessProductListState(productList));
        
        }catch(e){
          emit(ErrorProductListState(AppException()));
        }
      }
    });
  }
}
