


import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nike_store_flutter/data/local/hive.dart';
import 'package:nike_store_flutter/ui/product/product.dart';
import 'package:nike_store_flutter/ui/widgets/widgets.dart';

class FavoriteScreen extends StatefulWidget {
   FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
LocalHiveDataBase localHiveDataBase = LocalHiveDataBase();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('محصولات مورد علاقه')),
      body: localHiveDataBase.getAllFavorits().isEmpty ? Center(child: EmptyStateWidget(title: 'لیست علاقه مندی ها خالی است'),) :
      ListView.builder(itemCount: localHiveDataBase.getAllFavorits().length,itemBuilder: (context, index) {
        final product = localHiveDataBase.getAllFavorits()[index];
        return InkWell(
          onLongPress: (){
            setState(() {
              localHiveDataBase.deleteFavorite(product.id);
            });
          },
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product),)),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey,width: 1))),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              SizedBox(height: 120,child: ImageLoader(imageurl: product.imageUrl)),
              const SizedBox(width: 16,),
              Expanded(child: Text(product.title,style: theme.textTheme.headline6!.copyWith(fontSize: 18),)),
            ]),
          ),
        );
      },),
    );
  }
}