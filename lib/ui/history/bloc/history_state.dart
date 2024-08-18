part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  
  @override
  List<Object> get props => [];
}

class LoadingHistoryState extends HistoryState {}

class SuccussHistoryState extends HistoryState{
  final List<HistoryEntity> historyEntity;

  const SuccussHistoryState(this.historyEntity);

  @override
  // TODO: implement props
  List<Object> get props => [historyEntity];
}

class EmptyHistoryState extends HistoryState{
  
}

class ErrorHistoryState extends HistoryState{
final AppException appException;

  const ErrorHistoryState(this.appException);
  @override
  // TODO: implement props
  List<Object> get props => [appException];
}
