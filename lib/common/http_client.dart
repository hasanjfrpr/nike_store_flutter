

import 'package:dio/dio.dart';
import 'package:nike_store_flutter/data/local/shared.dart';

final Dio dio = Dio(BaseOptions(baseUrl: 'http://expertdevelopers.ir/api/v1/'))
..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {

      final token = LocalData.getToken().token;

      if(token.isNotEmpty && token!=''){
           options.headers['Authorization']='Bearer ${LocalData.getToken().token}';
          // options.headers['Content-Type']='application/json';
  
      }

handler.next(options);
 
},));