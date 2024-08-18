part of 'shipping_bloc.dart';

abstract class ShippingEvent extends Equatable {
  const ShippingEvent();

  @override
  List<Object> get props => [];
}

class OrderSubmitClickEvent extends ShippingEvent {
  final String name;
  final String lastName;
  final String mobile;
  final String address;
  final String postalCode;
  final String paymentMethod;

  const OrderSubmitClickEvent(this.name, this.lastName, this.mobile, this.address, this.postalCode, this.paymentMethod);
}
