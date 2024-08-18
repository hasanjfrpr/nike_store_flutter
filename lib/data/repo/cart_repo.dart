

import 'package:flutter/cupertino.dart';
import 'package:nike_store_flutter/common/http_client.dart';
import 'package:nike_store_flutter/data/models/cart_item.dart';
import 'package:nike_store_flutter/data/models/cart_response.dart';
import 'package:nike_store_flutter/data/source/cart_sounce.dart';




 ICartRepository cartRepository = CartRepositoryImpl(CartRemoteDataSourceImpl(dio));

abstract class ICartRepository {

  Future<CartResponse> add(int productId);
  Future<CartResponse> changeCount(int cartItemId,int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
   Future<CartList> getAll();


}

class CartRepositoryImpl implements ICartRepository{
  final ICartDataSource dataSource;
  static ValueNotifier<int> valueNotifierCount=ValueNotifier(0);

  CartRepositoryImpl(this.dataSource);
  @override
  Future<CartResponse> add(int productId) async{
    return dataSource.add(productId);
  }

  @override
  Future<CartResponse> changeCount(int cartItemId, int count) {
   return dataSource.changeCount(cartItemId, count);
  }

  @override
  Future<int> count() async{
    final count=await dataSource.count();
  valueNotifierCount.value=count;
  return count;
  }

  @override
  Future<void> delete(int cartItemId) {
    return dataSource.delete(  cartItemId);
  }

  @override
   Future<CartList> getAll() =>  dataSource.getAll();
  

}