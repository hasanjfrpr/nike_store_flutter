


import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nike_store_flutter/data/models/order.dart';
import 'package:nike_store_flutter/ui/receipt/payment_receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentUrlScreen extends StatelessWidget {
  const PaymentUrlScreen({super.key, required this.paymentResponse});
  final OrderResponseEntity paymentResponse;

  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl:paymentResponse.bankUrl ,
      zoomEnabled: true,
      onPageStarted: (url) {
        final uri = Uri.parse(url);
      
        
        if(uri.pathSegments.contains('checkout') && uri.host=='expertdevelopers.ir'){
          final id=int.parse(uri.queryParameters['order_id']!);
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>PaymentReceiptScreen(id: id,)));
        }
      },
    );
  }
}