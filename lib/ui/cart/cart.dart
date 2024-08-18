
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store_flutter/common/utils.dart';
import 'package:nike_store_flutter/data/local/shared.dart';
import 'package:nike_store_flutter/data/models/auth.dart';
import 'package:nike_store_flutter/data/models/cart_item.dart';
import 'package:nike_store_flutter/data/repo/auth_repo.dart';
import 'package:nike_store_flutter/data/repo/cart_repo.dart';
import 'package:nike_store_flutter/data/source/cart_sounce.dart';
import 'package:nike_store_flutter/gen/assets.gen.dart';
import 'package:nike_store_flutter/ui/auth/auth.dart';
import 'package:nike_store_flutter/ui/cart/bloc/cart_bloc.dart';
import 'package:nike_store_flutter/ui/product/product.dart';
import 'package:nike_store_flutter/ui/shipping/shipping.dart';
import 'package:nike_store_flutter/ui/widgets/widgets.dart';

class CartScreen extends StatefulWidget{
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late ValueNotifier valueListenable ;
  late ValueNotifier productValueListenable;
 late CartBloc? cartBlocs;
 bool showFloatingAction=false;
 late StreamSubscription<CartState> streamSubscription;

  @override
  void initState() {
    
    valueListenable = AuthRepositoryImpl.valueNotifier;
    productValueListenable = CartRemoteDataSourceImpl.productValueNotifier;

    productValueListenable.addListener(() {
      cartBlocs?.add(CartStarted());
    });
    valueListenable.addListener(() {
      cartBlocs?.add(CartAuthChangedEvent());
    });
  super.initState();
  }

  @override
  void dispose() {
    valueListenable.dispose();
    productValueListenable.dispose();
    streamSubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    

    final theme = Theme.of(context);
   
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('سبد خرید'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: showFloatingAction,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: FloatingActionButton.extended(onPressed: (){
            if(cartBlocs?.state is CartSucces){
              Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
              return ShippingScreen(cartLlis: (cartBlocs?.state as CartSucces).cartList,);
            }))
            ); 
            }
           
          },
          label: Text('پرداخت',style: theme.textTheme.bodyText1!.copyWith(color: theme.colorScheme.onSecondary),),),
        ),
      ),
      body: BlocProvider(create: (context) {
        final cartBloc = CartBloc(cartRepository);
        cartBlocs=cartBloc;
       streamSubscription= cartBloc.stream.listen((state) {
          setState(() {
            showFloatingAction=state is CartSucces;
          });
        });
        cartBloc.add(CartStarted());
        return cartBloc;
      },
      child: BlocBuilder<CartBloc,CartState>(builder: (context, state) {
        if(state is CartError){
            return Center(child: ErrorWidget(state.appException));
        }else if(state is CartLoading){
            return const Center(child: CircularProgressIndicator(),);
        }else if(state is CartSucces ){
           // return _CartItemWidget(cartList: state.cartList,cartBloc: cartBlocs!,state: state,);
           
            return ListView.builder(itemCount: state.cartList.cartItemEntityList.length+1,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
            itemBuilder: (context, index) {
             
             if(index==state.cartList.cartItemEntityList.length){
                  return CartDetailWidget(theme: theme,cartList: state.cartList,);
              }else{
                

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface,
            boxShadow: [BoxShadow(color: theme.colorScheme.secondary.withOpacity(0.3),blurRadius: 12)]
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  height: 110,
                  child: InkWell(onTap: (() {
                    Navigator.of(context).push(MaterialPageRoute(builder: ((context) => ProductDetailsScreen(product: state.cartList.cartItemEntityList[index].productEntity))));
                  }),child: ClipRRect(borderRadius: BorderRadius.circular(12),child: ImageLoader(imageurl: state.cartList.cartItemEntityList[index].productEntity.imageUrl))),
                ),
                const SizedBox(width: 8,),
                Expanded(child: Text(state.cartList.cartItemEntityList[index].productEntity.title,style: theme.textTheme.bodyText2,))
              ],
            ),
          ),
          const SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  Column(children: [
                    const Text('تعداد'),
                    Row(children: [
                      IconButton(onPressed: (){
                        cartBlocs?.add(CartIncreasClickedEvent(state.cartList.cartItemEntityList[index]));
                      },icon: const Icon(CupertinoIcons.plus_rectangle),),
                      state.cartList.cartItemEntityList[index].showLoadingChangeCount?const CupertinoActivityIndicator() 
                      :Text(state.cartList.cartItemEntityList[index].count.toString()),
                      IconButton(onPressed: (){
                        cartBlocs?.add(CartDecreaseClickEvent(state.cartList.cartItemEntityList[index]));
                      },icon: const Icon(CupertinoIcons.minus_rectangle),),
                    ],)
                  ],),
                  Column(children: [
                    Text(state.cartList.cartItemEntityList[index].productEntity.perviousPrice.withPricelable,style: theme.textTheme.caption!.copyWith(decoration: TextDecoration.lineThrough),),
                    const SizedBox(height: 4,),
                    Text(state.cartList.cartItemEntityList[index].productEntity.price.withPricelable,style: theme.textTheme.bodyText2,)
                  ],)
              ],
            ),
          ),
          const Divider(),
          TextButton(onPressed: (){
            cartBlocs?.add(CartDeleteItemEvent(state.cartList.cartItemEntityList[index].id));
          },child:state.cartList.cartItemEntityList[index].showLoading?const CupertinoActivityIndicator(color: Colors.black): const Text('حدف از سبد خرید'),)
        ]),
      );
   
              }
       });
        }else if(state is CartAuthRequired){
            return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
            SizedBox(width: 110,height: 120,
            child: Assets.images.authRequired.svg(),
            ),
            const Text('لطفا ابتدا وارد حساب کاربری خود شوید'),
            MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),color: Colors.blue,onPressed: (){
              Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>const AuthScreen()));
              },child: Text('ورود به حساب',style: theme.textTheme.bodyText2!.copyWith(color:theme.colorScheme.onPrimary ),),)
          ],),
        );
        }else if (state is CartError){
              return ErrorWidget(state.appException);
        }else if(state is CartEmptyState){
         
            
         
          return const EmptyStateWidget(title: 'سبد خرید خالی است');
        }else{
          throw Exception('not widget build');
        }
      },),
      )
    );
  }
}

class CartDetailWidget extends StatelessWidget {
   CartDetailWidget({
    Key? key,
    required this.theme, required this.cartList,
    this.margin=true
  }) : super(key: key);

  final ThemeData theme;
  final CartList cartList;
  bool margin;

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity,
    margin:margin? const EdgeInsets.symmetric(horizontal: 16,vertical: 24):null,
    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
    decoration: BoxDecoration(color: theme.colorScheme.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(color: theme.colorScheme.onBackground.withOpacity(0.5),blurRadius: 4)])
    ,child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Text('مبلغ کل',style: theme.textTheme.bodyText1,),
        RichText(text: TextSpan(text: cartList.totalPrice.numberFormatter,
        style: theme.textTheme.bodyText1!.apply(fontWeightDelta: 100),
        children: [
          TextSpan(text: ' تومان',style: theme.textTheme.bodyText2)
        ]
        ),)
      ],),
      const Divider(),
       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Text(' هزینه ارسال',style: theme.textTheme.bodyText1,),
        RichText(text: TextSpan(text: cartList.shippinngCost.numberFormatter,
        style: theme.textTheme.bodyText1!.apply(fontWeightDelta: 100),
        children: [
          TextSpan(text: ' تومان',style: theme.textTheme.bodyText2)
        ]
        ),)
      ],),
      const Divider(),
       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Text(' مبلغ قابل پرداخت',style: theme.textTheme.bodyText1,),
        RichText(text: TextSpan(text: cartList.payablePrice.numberFormatter,
        style: theme.textTheme.bodyText1!.apply(fontWeightDelta: 100),
        children: [
          TextSpan(text: ' تومان',style: theme.textTheme.bodyText2)
        ]
        ),)
      ],),
      

    ]),);
  }
}

// class _CartItemWidget extends StatelessWidget {
//   final CartList cartList;
//   final CartBloc cartBloc;
//   final CartState state;
//   const _CartItemWidget({
//     Key? key, required this.cartList, required this.cartBloc, required this.state,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme   = Theme.of(context);
   
//   }
// }







// ValueListenableBuilder(
//         valueListenable: AuthRepositoryImpl.valueNotifier,
//         builder: (context, value, child) {
//           final token = LocalData.getToken().token;
//           return token.isEmpty || token=='' ? Center(
//           child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
//             const Text('لطفا ابتدا وارد حساب کاربری خود شوید'),
//             MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),color: Colors.blue,onPressed: (){
//               Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>const AuthScreen()));
//               },child: Text('ورود به حساب',style: theme.textTheme.bodyText2!.copyWith(color:theme.colorScheme.onPrimary ),),)
//           ],),
//         ):Center(
//           child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
//             const Text('خروج از حساب کاربری'),
//             MaterialButton(onPressed: (){
//               authRepository.logout();
//             },color: Colors.blue,)
//           ],),
//         );
//         },
        
//       )