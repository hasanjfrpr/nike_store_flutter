


import 'package:dio/dio.dart';
import 'package:nike_store_flutter/data/models/comment.dart';
import 'package:nike_store_flutter/common/http_validator.dart';

abstract class ICommentDataSource{
  Future<List<CommentEntity>> getComments(int productId);
}


class CommentRemoteDataSourceImpl with ValidatorResponse implements ICommentDataSource{

  final Dio dio;

  CommentRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CommentEntity>> getComments(int productId) async{
    final comments=<CommentEntity>[];
    final response = await dio.get('comment/list?product_id=$productId');
    validationResponse(response);
    (response.data as List).forEach((element) { 
      comments.add(CommentEntity.fromJson(element));
    });

    return comments;
  }

}