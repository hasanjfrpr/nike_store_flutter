part of 'shipping_bloc.dart';

abstract class ShippingState extends Equatable {
  const ShippingState();
  
  @override
  List<Object> get props => [];
}

class ShippingInitial extends ShippingState {}

class ShippingLoadinState extends ShippingState{

}

class ShippingSuccess extends ShippingState{
  final OrderResponseEntity orderResponseEntity;

  const ShippingSuccess(this.orderResponseEntity);

  @override
  
  List<Object> get props => [orderResponseEntity];
}


class ShippingErrorstate extends ShippingState{
  final AppException appException;

  const ShippingErrorstate(this.appException);
}
