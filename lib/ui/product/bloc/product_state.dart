part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoadingState extends ProductState{

}

class ProductErrorState extends ProductState{
  final AppException message;

  const ProductErrorState(this.message);
}
class ProductSuccessState extends ProductState{
  
}
