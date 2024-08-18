import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/data/models/comment.dart';
import 'package:nike_store_flutter/data/repo/comment_repo.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {

final ICommentRepository commentRepository;
final int productId;
  CommentBloc({required this.commentRepository  , required this.productId}) : super(CommentLoading()) {
    on<CommentEvent>((event, emit) async{
      if(event is CommentStarted || event is CommentRefreshing){
        emit(CommentLoading());
        try{
          final comment = await commentRepository.getComments(productId);
          emit(CommentSuccess(comments: comment));
        }catch(e){
          emit(CommentError(exception: AppException()));
        }
      }
    });
  }
}
