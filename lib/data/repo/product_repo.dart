

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nike_store_flutter/common/http_client.dart';
import 'package:nike_store_flutter/data/models/product.dart';
import 'package:nike_store_flutter/data/source/product_source.dart';



IProductRepository productRepository = ProductRepoImpl(productDataSource: ProductRemoteDataSourceImpl(dio));


abstract class IProductRepository{

Future<List<ProductEntity>> getAllProducts(int sort);
Future<List<ProductEntity>> getAllProductBySearch(String keyTerm);

}


class ProductRepoImpl implements IProductRepository{

final IProductDataSource productDataSource;


  ProductRepoImpl({required this.productDataSource});

  @override
  Future<List<ProductEntity>> getAllProductBySearch(String keyTerm) =>productDataSource.getAllProductBySearch(keyTerm);

  @override
  Future<List<ProductEntity>> getAllProducts(int sort)=>productDataSource.getAllProducts(sort);

}