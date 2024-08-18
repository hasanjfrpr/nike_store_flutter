

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store_flutter/common/utils.dart';
import 'package:nike_store_flutter/data/models/cart_item.dart';
import 'package:nike_store_flutter/data/repo/order_repo.dart';
import 'package:nike_store_flutter/ui/cart/cart.dart';
import 'package:nike_store_flutter/ui/payment_getWay/payment_getway_url.dart';
import 'package:nike_store_flutter/ui/receipt/payment_receipt.dart';
import 'package:nike_store_flutter/ui/shipping/bloc/shipping_bloc.dart';
import 'package:nike_store_flutter/ui/widgets/widgets.dart';

class ShippingScreen extends StatelessWidget {
    ShippingScreen({super.key, required this.cartLlis});
  final CartList cartLlis;
  TextEditingController _nameTextEditingController=TextEditingController();
  TextEditingController _numberTextEditingControler=TextEditingController();
  TextEditingController _postalCodeTextEditingController=TextEditingController();
  TextEditingController _addressTextEdintingController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title:const Text('اطلاعات خرید'),
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final shippingBloc=ShippingBloc(orderRepository);
          shippingBloc.stream.listen((state) {
            if(state is ShippingSuccess){
              if(state.orderResponseEntity.bankUrl.isNotEmpty || state.orderResponseEntity.bankUrl!=''){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PaymentUrlScreen(paymentResponse:state.orderResponseEntity)));
              }else{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PaymentReceiptScreen(id:state.orderResponseEntity.id)));
           
              }
                 }else if(state is ShippingErrorstate){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.appException.message),));
            }
          });
          return shippingBloc;
        },
        child: SingleChildScrollView(child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            CustomTextField(lable: 'نام و نام خانوادگی', textInputType: TextInputType.text,
             borderColor: Colors.grey.withOpacity(0.6), textEditingController: _nameTextEditingController),
            const SizedBox(height: 8,),
            CustomTextField(lable: 'شماره تماس', textInputType: TextInputType.text,
             borderColor: Colors.grey.withOpacity(0.6), textEditingController: _numberTextEditingControler),
            const SizedBox(height: 8,),
            CustomTextField(lable: "کدپستی", textInputType: TextInputType.text,
             borderColor: Colors.grey.withOpacity(0.6), textEditingController: _postalCodeTextEditingController),
            const SizedBox(height: 8,),
            CustomTextField(lable: "آدرس", textInputType: TextInputType.text,
             borderColor: Colors.grey.withOpacity(0.6), textEditingController: _addressTextEdintingController),
            const SizedBox(height: 24,),
            Text('جزئیات خرید',style: theme.textTheme.bodyText1,),
            const SizedBox(height: 8,),
            CartDetailWidget(theme: theme, cartList: cartLlis,margin:false),
            const SizedBox(height: 24,),
            BlocBuilder<ShippingBloc,ShippingState>(
              builder: (context, state) {
                if(state is ShippingLoadinState){
                    return const Center(child:  CupertinoActivityIndicator(),);
                }else{
                  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                MaterialButton(
                  onPressed: (){
                     BlocProvider.of<ShippingBloc>(context).add(OrderSubmitClickEvent(
                      _nameTextEditingController.text
                      , _nameTextEditingController.text, _numberTextEditingControler.text, 
                      _addressTextEdintingController.text, _postalCodeTextEditingController.text,'online'));
                  },
                  color: theme.colorScheme.primary,
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: const BorderSide(color: Colors.transparent)),
                  child: Text('پرداخت اینترنتی',style: theme.textTheme.bodyText2!.copyWith(color: theme.colorScheme.onPrimary),),
                ),
                MaterialButton(
                  onPressed: (){
                    BlocProvider.of<ShippingBloc>(context).add(OrderSubmitClickEvent(
                      _nameTextEditingController.text
                      , _nameTextEditingController.text, _numberTextEditingControler.text, 
                      _addressTextEdintingController.text, _postalCodeTextEditingController.text,'cash_on_delivery'));
                  },
                  color: theme.colorScheme.onPrimary,
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(12),borderSide: const BorderSide(color: Colors.transparent)),
                  child: Text('پرداخت درب منزل',style: theme.textTheme.bodyText2!.copyWith(color: theme.colorScheme.primary),),
                ),
                  
              ],);
           
                }
               
              },
               )
          ],),
        )),
      ),
    
    );
  }
}