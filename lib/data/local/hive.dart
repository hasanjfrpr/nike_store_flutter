
import 'package:hive_flutter/adapters.dart';
import 'package:nike_store_flutter/data/models/product.dart';

class LocalHiveDataBase {
  
  static const String productBoxName = 'productBox';
   final _box = Hive.box<ProductEntity>(productBoxName);

static Future<void> genearatedHive() async{
 await Hive.initFlutter();
  Hive.registerAdapter(ProductEntityAdapter());
  await Hive.openBox<ProductEntity>(productBoxName);
}


 void addFavorite(ProductEntity productEntity){
   
   _box.put(productEntity.id  ,productEntity);

}

void deleteFavorite(int productId){

  _box.delete(productId);

}

List<ProductEntity> getAllFavorits(){
  return _box.values.toList();
}

bool isFavorite(int productId){
 return _box.containsKey(productId);
}



}