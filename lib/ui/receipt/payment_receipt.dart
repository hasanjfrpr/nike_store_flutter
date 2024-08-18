

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('رسید پرداخت'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.onBackground)
            ),
            child: Column(children: [
              Text('خرید با موفقیت انجام شد',style: theme.textTheme.headline6!.copyWith(color: Colors.green),),
            SizedBox(height: 4,),
            Divider(color: theme.colorScheme.onBackground),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Text('وضعیت سفارش'),
              Text(' موفق'),
            ],),
            SizedBox(height: 4,),
            Divider(color: theme.colorScheme.onBackground),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Text('مبلغ'),
              Text(id.toString()),
            ],),
            ]),
          ),
          ElevatedButton(onPressed: (){
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Text('بازگشت به صفحه اصلی'),
          )
        ],
        
      ),
    );
  }
}