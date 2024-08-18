

import 'package:nike_store_flutter/common/http_client.dart';
import 'package:nike_store_flutter/data/models/banner.dart';
import 'package:nike_store_flutter/data/source/banner_source.dart';




final bannerRepository = BannerRepositoryImpl(BannerRemoteDataSourceImpl(dio));


abstract class IBannerRepository{
Future<List<BannerEntity>>  getBanners();
}


class BannerRepositoryImpl implements IBannerRepository{

final IBannerDataSource bannerDataSource;

  BannerRepositoryImpl(this.bannerDataSource);

  @override
  Future<List<BannerEntity>> getBanners() => bannerDataSource.getBanners();

}