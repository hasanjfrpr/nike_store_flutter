import 'package:flutter/cupertino.dart';
import 'package:nike_store_flutter/common/http_client.dart';
import 'package:nike_store_flutter/data/local/shared.dart';
import 'package:nike_store_flutter/data/models/auth.dart';
import 'package:nike_store_flutter/data/repo/cart_repo.dart';
import 'package:nike_store_flutter/data/source/auth_source.dart';

abstract class IAuthRepository {
  Future<void> login(String userName, String passWord);
  Future<void> signUp(String userName, String passWord);
  Future<void> refreshingToken();
  Future<void> logout();
}

final IAuthRepository authRepository = AuthRepositoryImpl(AuthRemoteDataSourceImpl(dio));

class AuthRepositoryImpl implements IAuthRepository{

final IAuthDataSource dataSource;
static  ValueNotifier<AuthEntity> valueNotifier = ValueNotifier(AuthEntity('',''));

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<void> login(String userName, String passWord) async{
    final AuthEntity authEntity=await dataSource.login(userName, passWord);
    LocalData.setToken(authEntity.token,authEntity.refreshToken);
LocalData.setUsername(userName);
    valueNotifier.value=authEntity;
    cartRepository.count();
  }

  @override
  Future<void> refreshingToken() async{
    final AuthEntity authEntity = await dataSource.refreshingToken(LocalData.getToken().refreshToken);
    LocalData.setToken(authEntity.token,authEntity.refreshToken);
    valueNotifier.value=authEntity;
  }

  @override
  Future<void> signUp(String userName, String passWord) async{
    await dataSource.signUp(userName, passWord);
     final AuthEntity authEntity =await dataSource.login(userName, passWord);
   LocalData.setToken(authEntity.token,authEntity.refreshToken);
  
   valueNotifier.value=authEntity;
   cartRepository.count();
  }
  
  @override
  Future<void> logout() async{
   await LocalData.clearSharedPref();
   valueNotifier.value = AuthEntity('','');
   LocalData.setUsername('');
  
   CartRepositoryImpl.valueNotifierCount.value=0;
  }
    
}
