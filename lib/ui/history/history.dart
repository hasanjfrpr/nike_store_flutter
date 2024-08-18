import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store_flutter/common/utils.dart';
import 'package:nike_store_flutter/data/repo/order_repo.dart';
import 'package:nike_store_flutter/ui/history/bloc/history_bloc.dart';
import 'package:nike_store_flutter/ui/product/product.dart';
import 'package:nike_store_flutter/ui/widgets/widgets.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
final theme = Theme.of(context);
    return Scaffold(
      backgroundColor:theme.colorScheme.surface,
        appBar: AppBar(title: const Text('سوابق خرید')),
        body: BlocProvider<HistoryBloc>(
          create: (context) {
            return HistoryBloc(orderRepository)..add(StartedHistoryEvent());
          },
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state is LoadingHistoryState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SuccussHistoryState) {
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.historyEntity.length,
                    itemBuilder: ((context, index) {
                      var historyitem = state.historyEntity[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey, width: 1.5)),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        margin: EdgeInsets.all(16),
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text('شناسه خرید ',style: theme.textTheme.bodyText2,),
                                Text(historyitem.id.toString())
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text('مبلغ پرداختی',style: theme.textTheme.bodyText2),
                                Text(historyitem.payablePrice
                                    .toInt()
                                    .withPricelable)
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: historyitem.orderItems.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailsScreen(
                                                    product: historyitem
                                                        .orderItems[index]),
                                          ));
                                        },
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: ImageLoader(
                                                imageurl: historyitem
                                                    .orderItems[index]
                                                    .imageUrl))));
                              },
                            ),
                          )
                        ]),
                      );
                    }));
              }else if(state is EmptyHistoryState){
                  return const Center(child: EmptyStateWidget(title: 'سوابق خرید شما خالی است'),);
              } else if (state is ErrorHistoryState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.appException.message),
                ));
                return Container();
              } else {
                throw Exception('history cant build');
              }
            },
          ),
        ));
  }
}
