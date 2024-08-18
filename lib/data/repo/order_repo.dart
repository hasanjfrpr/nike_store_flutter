

import 'package:nike_store_flutter/common/http_client.dart';
import 'package:nike_store_flutter/data/models/history_model.dart';
import 'package:nike_store_flutter/data/models/order.dart';
import 'package:nike_store_flutter/data/source/order_source.dart';



IOrderRepository orderRepository = OrderRepositoryImpl(OrderRemoteDataSourceImpl(dio));

abstract class IOrderRepository{
Future<OrderResponseEntity> order(String name,String lastName,String mobile,String address,String postalCode,String paymentMethod);
Future<List<HistoryEntity>> getHistory();
}

class OrderRepositoryImpl implements IOrderRepository{
  final IOrderDataSource dataSource;

  OrderRepositoryImpl(this.dataSource);
  @override
  Future<OrderResponseEntity> order(String name, String lastName, String mobile, String address, String postalCode, String paymentMethod) {
   return dataSource.order(name, lastName, mobile, address, postalCode, paymentMethod);
  }
  
  @override
  Future<List<HistoryEntity>> getHistory() {
    return dataSource.getHistory();
  }

}