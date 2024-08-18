import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store_flutter/data/models/product.dart';
import 'package:nike_store_flutter/data/repo/product_repo.dart';
import 'package:nike_store_flutter/ui/product/product.dart';
import 'package:nike_store_flutter/ui/product_list/bloc/product_list_bloc.dart';
import 'package:nike_store_flutter/ui/widgets/widgets.dart';

class ProductListScreen extends StatefulWidget {
  ProductListScreen(
      {super.key, required this.sort, required this.productEntity});
  final int sort;
  final List<ProductEntity> productEntity;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  
  final map = {
    '${ProductSort.latest}': 'جدیدترین ها',
    '${ProductSort.popular}': 'پربازدیدترین ها',
    '${ProductSort.priceHighToLow}': 'ارزان ترین ها',
    '${ProductSort.priceLowToHigh}': 'گران ترین ها',
  };
  bool isGrid = true;

  ProductListBloc? productsBloc;
  ValueNotifier<int> _notifierSort=ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    _notifierSort.value=widget.sort;
    final theme = Theme.of(context);
    return  Scaffold(
        appBar: AppBar(
          title: Text('کفش های ورزشی'),
          backgroundColor: theme.colorScheme.surface,
        ),
        body:BlocProvider<ProductListBloc>(
      create: (context) {
          final productListBloc = ProductListBloc(productRepository);
          productListBloc.add(StartProductListEvent());
          productsBloc=productListBloc;
          return productListBloc;
      },
      child: Column(children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                    top: BorderSide(color: theme.textTheme.caption!.color!))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: ((context) {
                            return BlocProvider.value(
                              value:productsBloc! ,
                              child: Container(
                                height: 250,
                                  width: double.infinity,
                                  child: ListView.builder(
                                      itemCount: map.length,
                                      itemBuilder: ((context, index) {
                                        return ListTile(
                                          onTap: (){
                                              Navigator.of(context).pop();
                                              _notifierSort.value=index;
                                              productsBloc!.add(SortProductListEvent(index));
                                          },
                                          trailing: index == _notifierSort.value
                                              ? Container(
                                                alignment: Alignment.center,
                                                  width: 30,
                                                  height: 30,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.green,
                                                      shape: BoxShape.circle),
                                                  child:const Icon(
                                                    CupertinoIcons.check_mark,
                                                    color: Colors.white,
                                                  ))
                                              : null,
                                          title: Text(
                                            map['${index}'].toString(),
                                            style: theme.textTheme.bodyText2,
                                          ),
                                        );
                                      }))),
                            );
                          }));
                    },
                    child: Container(
                      child: Row(children: [
                        Icon(CupertinoIcons.sort_up),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('مرتب سازی'),
                            ValueListenableBuilder(
                              valueListenable: _notifierSort,
                              builder: (context, value, child) => Text(
                                map['${_notifierSort.value}'].toString(),
                                style: theme.textTheme.caption,
                              ),
                              
                            ),
                          ],
                        )
                      ]),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.textTheme.caption!.color!,
                ),
                const SizedBox(
                  width: 16,
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        isGrid = !isGrid;
                      });
                    },
                    child: Icon(isGrid
                        ? CupertinoIcons.square_grid_2x2
                        : CupertinoIcons.square)),
              ]),
            ),
          ),
          Expanded(
              child: BlocBuilder<ProductListBloc,ProductListState>(
                builder: (context, state) {
                  if(state is StartedFirstTimeProductListState){
                    return  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isGrid ? 2 : 1,
                      childAspectRatio: isGrid ? 0.55 : 0.65,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 36
                    ),
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: widget.productEntity.length,
                    itemBuilder: ((context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                    product: widget.productEntity[index])));
                          },
                          child: ProductWidget(
                              productItem: widget.productEntity[index],
                              borderRadius: BorderRadius.zero));
                    }));
                  }else if(state is SuccessProductListState){
                    return  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isGrid ? 2 : 1,
                      childAspectRatio: isGrid ? 0.55 : 0.65,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 36
                    ),
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: state.products.length,
                    itemBuilder: ((context, index) {
                      return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                    product: state.products[index])));
                          },
                          child: ProductWidget(
                              productItem: state.products[index],
                              borderRadius: BorderRadius.zero));
                    }));
                  }else if(state is LoadingProductListState){
                      return const Center(child:  CircularProgressIndicator(),);
                  }else{
                      return Container(color: Colors.blue,);
                  }
                },

               
              ))
        ]),
      ),
    );
  }
}
