

import 'package:nike_store_flutter/data/models/product.dart';

class HistoryEntity {
  final int id;
  final int payablePrice;
  final List<ProductEntity> orderItems;

  HistoryEntity.fromJson(Map<String,dynamic> json):id=json['id'],
  payablePrice=json['payable'],
  orderItems=(json['order_items'] as List).map((e) => ProductEntity.fromJson(e['product'])).toList();




}
