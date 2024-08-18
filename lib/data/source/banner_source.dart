

import 'package:dio/dio.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/common/http_validator.dart';
import 'package:nike_store_flutter/data/models/banner.dart';

abstract class IBannerDataSource{
Future<List<BannerEntity>>  getBanners();
}


class BannerRemoteDataSourceImpl with ValidatorResponse implements IBannerDataSource{

final Dio dio;

  BannerRemoteDataSourceImpl(this.dio);

  @override
  Future<List<BannerEntity>> getBanners() async{
    final banners = <BannerEntity>[];

    final response = await dio.get('banner/slider');
    validationResponse(response);
    (response.data as List).forEach((element) { 

      banners.add(BannerEntity.fromJson(element));

    });

    return banners;
  }
  
 

}