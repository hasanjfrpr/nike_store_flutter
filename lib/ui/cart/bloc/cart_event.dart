part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}


class CartStarted extends CartEvent{

}

class CartAuthChangedEvent extends CartEvent{

}

class CartRefreshing extends CartState{

}

class CartDeleteItemEvent extends CartEvent{
  final int cartItemId;

  const CartDeleteItemEvent(this.cartItemId);

}

class CartIncreasClickedEvent extends CartEvent{
    final CartItemEntity cartItemEntity;

  const CartIncreasClickedEvent(this.cartItemEntity);
}
class CartDecreaseClickEvent extends CartEvent{
 final CartItemEntity cartItemEntity;

  const CartDecreaseClickEvent(this.cartItemEntity);
}


