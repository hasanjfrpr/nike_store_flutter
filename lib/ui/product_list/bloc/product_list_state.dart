part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();
  
  @override
  List<Object> get props => [];
}

class LoadingProductListState extends ProductListState {}

class StartedFirstTimeProductListState extends ProductListState{
  
}

class ErrorProductListState extends ProductListState{
  final AppException appException;
  const ErrorProductListState(this.appException);
}

class SuccessProductListState extends ProductListState{
  final List<ProductEntity> products;

  const SuccessProductListState(this.products);
}

class RefreshingProductListState extends ProductListState{
  final List<ProductEntity> products;

  const RefreshingProductListState(this.products);


}
