

import 'package:dio/dio.dart';
import 'package:nike_store_flutter/common/http_validator.dart';
import 'package:nike_store_flutter/data/models/history_model.dart';
import 'package:nike_store_flutter/data/models/order.dart';


abstract class IOrderDataSource{
Future<OrderResponseEntity> order(String name,String lastName,String mobile,String address,String postalCode,String paymentMethod);
Future<List<HistoryEntity>> getHistory();
}
class OrderRemoteDataSourceImpl with ValidatorResponse implements IOrderDataSource{

final Dio dio;

  OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<OrderResponseEntity> order(String name, String lastName, String mobile, String address, String postalCode, String paymentMethod) async{
    final response = await dio.post('order/submit',data: {
      'first_name':name,
      'last_name':lastName,
      'mobile':mobile,
      'postal_code':postalCode,
      'address':address,
      'payment_method':paymentMethod,

    });
    validationResponse(response);
    return OrderResponseEntity.fromJson(response.data);
  
  }
  
  @override
  Future<List<HistoryEntity>> getHistory() async{
    final List<HistoryEntity> histories = <HistoryEntity>[];

    final response = await dio.get('order/list');
    validationResponse(response);
    (response.data as List).forEach((element) {
      histories.add(HistoryEntity.fromJson(element));
    });
    return histories;
  }

}