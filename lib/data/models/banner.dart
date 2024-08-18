
class BannerEntity{

final int id;
final String imageurl;

BannerEntity.fromJson(Map<String , dynamic> json):id=json['id'],imageurl=json['image'];

}