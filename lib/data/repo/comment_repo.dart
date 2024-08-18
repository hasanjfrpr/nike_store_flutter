

import 'package:nike_store_flutter/common/http_client.dart';
import 'package:nike_store_flutter/data/models/comment.dart';
import 'package:nike_store_flutter/data/source/comment_source.dart';



final commentRepo = CommentRepositoryImpl(CommentRemoteDataSourceImpl(dio));


abstract class ICommentRepository{
  Future<List<CommentEntity>> getComments(int productId);
}


class CommentRepositoryImpl implements ICommentRepository{

final ICommentDataSource commentDataSource;

  CommentRepositoryImpl(this.commentDataSource);

  @override
  Future<List<CommentEntity>> getComments(int productId) {
    return commentDataSource.getComments(productId);
  }

}