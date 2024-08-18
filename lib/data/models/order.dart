

class OrderResponseEntity{
  final int id;
  final String bankUrl;

  OrderResponseEntity.fromJson(Map<String , dynamic> json):id=json['order_id'],bankUrl=json['bank_gateway_url'];
}