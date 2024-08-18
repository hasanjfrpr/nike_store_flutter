import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/data/local/shared.dart';
import 'package:nike_store_flutter/data/models/auth.dart';
import 'package:nike_store_flutter/data/models/cart_item.dart';
import 'package:nike_store_flutter/data/repo/cart_repo.dart';
import 'package:nike_store_flutter/ui/main/main.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted || event is CartRefreshing) {
        if (LocalData.getToken().token.isEmpty ||
            LocalData.getToken().token == '') {
          emit(CartAuthRequired());
        } else {
          try {
            emit(CartLoading());
            final cartList = await cartRepository.getAll();
            await cartRepository.count();
            if(cartList.cartItemEntityList.isEmpty){
                emit(CartEmptyState());
            }else{ emit(CartSucces(cartList));}
           
          } catch (e) {
            emit(CartError(AppException()));
          }
        }
      } else if (event is CartAuthChangedEvent) {
        if (LocalData.getToken().token.isEmpty ||
            LocalData.getToken().token == '') {
          emit(CartAuthRequired());
        } else {
          try {
            emit(CartLoading());
            final cartList = await cartRepository.getAll();
            if(cartList.cartItemEntityList.isEmpty){
                emit(CartEmptyState());
            }else{ emit(CartSucces(cartList));}
          } catch (e) {
            emit(CartError(AppException()));
          }
        }
      } else if (event is CartDeleteItemEvent) {
        
        if(state is CartSucces){
        try {
          // emit(CartDeleteLoadingState());
          (state as CartSucces).cartList.cartItemEntityList.firstWhere((element){
            if(element.id==event.cartItemId){
             return element.showLoading=true;
            }else{
              return element.showLoading=false;
            }
          });
          emit(CartSucces((state as CartSucces).cartList));
          await cartRepository.delete(event.cartItemId);
         final cartlist= await cartRepository.getAll();
         await cartRepository.count();
        if(cartlist.cartItemEntityList.isEmpty){
                emit(CartEmptyState());
            }else{ emit(CartSucces(cartlist));}
          
          
          
        } catch (e) {
          throw Exception('delete item has problem');
        }
      
      }
      }else if(event is CartIncreasClickedEvent){
          if(state is CartSucces){
            try{
             
              if(event.cartItemEntity.count<5 && event.cartItemEntity.count>0){
                 final cartList = (state as CartSucces).cartList;
              cartList.cartItemEntityList.forEach((element) {
                if(element.id==event.cartItemEntity.id){
                  element.showLoadingChangeCount=true;
                }
              });
              emit(CartSucces((state as CartSucces).cartList));
                 await cartRepository.changeCount(event.cartItemEntity.id, event.cartItemEntity.count+1);
              final cartLists = await cartRepository.getAll();
              await cartRepository.count();
              emit(CartSucces(cartLists));
              }
             

            }catch(e){
                emit(CartError(AppException()));
            }
          }
      }else if(event is CartDecreaseClickEvent){
        if(state is CartSucces){
             if(state is CartSucces){
            try{
             
              if(event.cartItemEntity.count<6 && event.cartItemEntity.count>1){
                 final cartList = (state as CartSucces).cartList;
              cartList.cartItemEntityList.forEach((element) {
                if(element.id==event.cartItemEntity.id){
                  element.showLoadingChangeCount=true;
                }
              });
              emit(CartSucces((state as CartSucces).cartList));
                 await cartRepository.changeCount(event.cartItemEntity.id, event.cartItemEntity.count-1);
              final cartLists = await cartRepository.getAll();
             await cartRepository.count();
              emit(CartSucces(cartLists));
              }
             

            }catch(e){
                emit(CartError(AppException()));
            }
          }
      }
      }
    });
  }
}
