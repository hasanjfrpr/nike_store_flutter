
import 'package:dio/dio.dart';
import 'package:nike_store_flutter/common/exception.dart';

mixin ValidatorResponse{
   void validationResponse(Response response) {
    if(response.statusCode!=200){
      throw AppException(message: "خطای نامشخص");
    }
  }
}