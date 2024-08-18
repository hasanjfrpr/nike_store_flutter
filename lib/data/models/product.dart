
import 'package:hive_flutter/hive_flutter.dart';

part 'product.g.dart';



@HiveType(typeId: 0)
class ProductEntity extends HiveObject{
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final int price;
  @HiveField(4)
  final int discount;
  @HiveField(5)
  final int perviousPrice;

  ProductEntity(this.discount,this.id,this.imageUrl,this.perviousPrice,this.price,this.title);

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        imageUrl = json['image'],
        price = json['price'],
        perviousPrice = json['previous_price'] ?? json['price'],
        discount = json['discount'];
}


class ProductSort {
  static const int latest = 0;
  static const int popular = 1;
  static const int priceHighToLow = 2;
  static const int priceLowToHigh = 3;
}