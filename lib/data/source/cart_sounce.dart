

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nike_store_flutter/common/http_validator.dart';

import '../models/cart_item.dart';
import '../models/cart_response.dart';

abstract class ICartDataSource {

  Future<CartResponse> add(int productId);
  Future<CartResponse> changeCount(int cartItemId,int count);
  Future<void> delete(int cartItemId);
  Future<int> count();
  Future<CartList> getAll();

}



class CartRemoteDataSourceImpl with ValidatorResponse implements ICartDataSource{
  final Dio dio;
  static ValueNotifier productValueNotifier=ValueNotifier(null);

  CartRemoteDataSourceImpl(this.dio);
  @override
  Future<CartResponse> add(int productId) async{
    final  response = await dio.post('cart/add',data: {
      'product_id':productId
    });
  validationResponse(response);
  productValueNotifier.value=CartResponse.fromJson(response.data);
  return CartResponse.fromJson(response.data);
  }

  @override
  Future<CartResponse> changeCount(int cartItemId, int count) async{
    final response = await dio.post('cart/changeCount',data: {
        "cart_item_id":cartItemId,
        "count":count
    });

    validationResponse(response);
    return CartResponse.fromJson(response.data);

    
  }

  @override
  Future<int> count() async{
    final count = await dio.get('cart/count');
    validationResponse(count);
    return count.data['count'];
  
  }

  @override
  Future<void> delete(int cartItemId) async{
    final response = await dio.post('cart/remove',data: {
        'cart_item_id':cartItemId
    });
    validationResponse(response);
    
  }

  @override
  Future<CartList> getAll() async{
    final response =await dio.get('cart/list');
    validationResponse(response);
    return CartList.fromJson(response.data);
  }
  
}