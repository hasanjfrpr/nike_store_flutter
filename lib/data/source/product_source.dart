

import 'package:dio/dio.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/common/http_validator.dart';

import '../models/product.dart';

abstract class IProductDataSource{

Future<List<ProductEntity>> getAllProducts(int sort);
Future<List<ProductEntity>> getAllProductBySearch(String keyTerm);

}


class ProductRemoteDataSourceImpl with ValidatorResponse implements IProductDataSource{

final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductEntity>> getAllProductBySearch(String keyTerm) async{
     List<ProductEntity> productList=[];

    final response = await dio.get('product/list?sort=$keyTerm');
    validationResponse(response);
    (response.data as List).forEach((element) { 
      productList.add(ProductEntity.fromJson(element));
    });
    
    return productList;

  }

  @override
  Future<List<ProductEntity>> getAllProducts(int sort) async{

    List<ProductEntity> productList=[];

    final response = await dio.get('product/list?sort=$sort');
    validationResponse(response);
    (response.data as List).forEach((element) { 
      productList.add(ProductEntity.fromJson(element));
    });
    
    return productList;

    
  }


  

}


