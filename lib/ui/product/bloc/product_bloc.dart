import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/data/repo/cart_repo.dart';
import 'package:nike_store_flutter/data/repo/product_repo.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository repository;
  ProductBloc(this.repository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async{
   
      try{
          if(event is PruductAddToCartClickEvent){
            emit(ProductLoadingState());
          final cartResponse=await repository.add(event.produtId);
            emit(ProductSuccessState());
          }
      }catch(e){
        emit(ProductErrorState(AppException()));
      }

    });
  }
}
