part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}


class PruductAddToCartClickEvent extends ProductEvent{
  final int produtId;

  const PruductAddToCartClickEvent(this.produtId);
}
