import 'package:dio/dio.dart';
import 'package:nike_store_flutter/common/http_validator.dart';
import 'package:nike_store_flutter/data/models/auth.dart';

abstract class IAuthDataSource {
  Future<AuthEntity> login(String userName, String passWord);
  Future<AuthEntity> signUp(String userName, String passWord);
  Future<AuthEntity> refreshingToken(String token);
}

class AuthRemoteDataSourceImpl
    with ValidatorResponse
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSourceImpl(this.httpClient);

  @override
  Future<AuthEntity> login(String userName, String passWord) async {
    var response = await httpClient.post('auth/token', data: {
      'grant_type': 'password',
      'client_id': 2,
      'client_secret': 'kyj1c9sVcksqGU4scMX7nLDalkjp2WoqQEf8PKAC',
      'username': userName,
      'password': passWord
    });
    validationResponse(response);
      
    return AuthEntity.fromJson(response.data);
  }

  @override
  Future<AuthEntity> refreshingToken(String token) async{
    var response = await httpClient.post('auth/token',data: {
      'grant_type':'refresh_token',
      'refresh_token':token,
      'client_id':'2',
      'client_secret':'kyj1c9sVcksqGU4scMX7nLDalkjp2WoqQEf8PKAC',
    });
    validationResponse(response);
    return AuthEntity.fromJson(response.data);
  }

  @override
  Future<AuthEntity> signUp(String userName, String passWord) async {
    var response = await httpClient.post('user/register',
        data: {"email": userName, "password": passWord});

        validationResponse(response);
        return login(userName, passWord);
  }
}
