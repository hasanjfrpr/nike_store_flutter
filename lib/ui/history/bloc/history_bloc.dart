import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/data/repo/order_repo.dart';

import '../../../data/models/history_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final IOrderRepository repository;
  HistoryBloc(this.repository) : super(LoadingHistoryState()) {
    on<HistoryEvent>((event, emit) async{
      if(event is StartedHistoryEvent){
        emit(LoadingHistoryState());
        try{
              final historyEntity = await repository.getHistory();
              if(historyEntity.isEmpty){
                emit(EmptyHistoryState());
              }else{
              emit(SuccussHistoryState(historyEntity));  
              }
              
        }catch(e){
            emit(ErrorHistoryState(AppException()));
        }
      }
    });
  }
}
