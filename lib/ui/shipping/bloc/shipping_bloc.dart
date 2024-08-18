import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/data/models/order.dart';
import 'package:nike_store_flutter/data/repo/order_repo.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IOrderRepository orderRepository;
  ShippingBloc(this.orderRepository) : super(ShippingInitial()) {
    on<ShippingEvent>((event, emit) async{
      if(event is OrderSubmitClickEvent){
        try{
          emit(ShippingLoadinState());
        final orderResponseEntity = await orderRepository.order(event.name, event.lastName, event.mobile,
        event.address, event.postalCode, event.paymentMethod);

      emit(ShippingSuccess(orderResponseEntity));
        }catch(e){
          emit(ShippingErrorstate(AppException()));
        }

      }
    });
  }
}
