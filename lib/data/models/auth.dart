

class AuthEntity {
  String token;
  String refreshToken;
 
  AuthEntity(this.token , this.refreshToken);
  AuthEntity.fromJson(Map<String , dynamic> json):token=json['access_token'],refreshToken=json['refresh_token'];
}