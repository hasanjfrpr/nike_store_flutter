part of 'cart_bloc.dart';

abstract class CartState  {
  const CartState();
  
 
}

class CartLoading extends CartState {}

class CartSucces extends CartState{
  final CartList cartList;

  const CartSucces(this.cartList);

}

class CartError extends CartState{
final AppException appException;
const CartError(this.appException);


}


class CartEmptyState extends CartState{
  
}



class CartChangeAuth extends CartState{

}

class CartAuthRequired extends CartState{
  
}

class CartDeleteLoadingState extends CartState{

}

class CartSuccessDeleteState extends CartState{
  final CartList cartList;
  const CartSuccessDeleteState(this.cartList);
}