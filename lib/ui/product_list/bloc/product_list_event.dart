part of 'product_list_bloc.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object> get props => [];
}

class StartProductListEvent extends ProductListEvent{}

class SortProductListEvent extends ProductListEvent{
  final int sort;

  const SortProductListEvent(this.sort);
}