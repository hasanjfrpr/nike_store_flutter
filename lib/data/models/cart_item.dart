import 'package:nike_store_flutter/data/models/product.dart';

class CartItemEntity {
  final ProductEntity productEntity;
   int count;
  final int id;
bool showLoading=false;
bool showLoadingChangeCount=false;

  CartItemEntity.fromJson(Map<String,dynamic> json):
  productEntity=ProductEntity.fromJson(json['product']),
  id=json['cart_item_id'],
  count=json['count'];
   

  static List<CartItemEntity> jsonArrayToDartList(List<dynamic> arryList){
    final List<CartItemEntity> cartItemEntityList=[];
    arryList.forEach((element) {
      cartItemEntityList.add(CartItemEntity.fromJson(element));
    });

    return cartItemEntityList;
  }
}



class CartList{
  final List<CartItemEntity> cartItemEntityList;
  final int payablePrice;
  final int totalPrice;
  final int shippinngCost;

  CartList.fromJson(Map<String , dynamic> json)
  :cartItemEntityList=CartItemEntity.jsonArrayToDartList(json['cart_items']),
  totalPrice=json['total_price'],
  shippinngCost=json['shipping_cost'],
  payablePrice=json['payable_price'];
}