
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nike_store_flutter/common/utils.dart';
import 'package:nike_store_flutter/data/local/hive.dart';
import 'package:nike_store_flutter/gen/assets.gen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../data/models/banner.dart';
import '../../data/models/product.dart';

class ImageLoader extends StatelessWidget {
  
final String imageurl;

  const ImageLoader({
    Key? key, required this.imageurl,
    
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageurl,
      fit: BoxFit.cover,
      placeholder: ((context, url) =>Assets.images.placeHolder.image(fit: BoxFit.cover)),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}



class ProductWidget extends StatefulWidget {
   ProductWidget({
    Key? key,
    required this.productItem, required this.borderRadius, 
  }) : super(key: key);

  final ProductEntity productItem;
  final BorderRadius borderRadius;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  final localHive = LocalHiveDataBase();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 0.8,
              child: ClipRRect(
                  borderRadius: widget.borderRadius,
                  child:
                      ImageLoader(imageurl: widget.productItem.imageUrl)),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: (){

                    setState(() {
                      if(localHive.isFavorite(widget.productItem.id)){
                  localHive.deleteFavorite(widget.productItem.id);
                 } else{
                  localHive.addFavorite(widget.productItem);
                 }
                 
                    });
                 
                },
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<ProductEntity>(LocalHiveDataBase.productBoxName).listenable(),
                  builder: (context, box, child) {
                   return Container(
                    width: 30,
                    height: 30,
                    child:  Center(child: Icon(localHive.isFavorite(widget.productItem.id)? CupertinoIcons.heart_fill : CupertinoIcons.heart)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.onPrimary),
                  );
                  },
                   
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
              child: Text(
          widget.productItem.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyText1,
        ),
            )),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 1),
          child: Text(
            widget.productItem.perviousPrice.withPricelable,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(decoration: TextDecoration.lineThrough),
          ),
        ),
        Padding(
           padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 1),
          child: Text(widget.productItem.price.withPricelable),
        )
      ],
    );
  }
}




class Errorwidget extends StatelessWidget {


final Function() onTap;
final String message;

  const Errorwidget({
    Key? key,required this.message , required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.symmetric(horizontal: 24),
      child: MaterialButton(
        onPressed: onTap,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.refresh,
                color: Theme.of(context).colorScheme.onPrimary),
            const SizedBox(
              width: 4,
            ),
            Text(
             message,
              style: Theme.of(context).textTheme.bodyText2!.apply(
                  color: Theme.of(context).colorScheme.onPrimary),
            )
          ],
        ),
      ),
    );
  }
}


class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center
        ,children: [
        SizedBox(width: 100,height: 110,child: Assets.images.emptyCart.svg()),
        SizedBox(height: 4,),
        Text(title,style: Theme.of(context).textTheme.bodyText2,)
      ]),
    );
  }
}

class CustomTextField extends StatelessWidget{
  final String lable;
  final TextInputType textInputType;
  final TextEditingController textEditingController;

  final Color borderColor;

  const CustomTextField({super.key, required this.lable, required this.textInputType, required this.borderColor, required this.textEditingController});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
         colorScheme: theme.colorScheme.copyWith(
              onSurface: theme.colorScheme.onBackground
      ),
      ),
      child: TextField(
        controller: textEditingController,
        keyboardType: textInputType,
        decoration: InputDecoration(
       disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color:Theme.of(context).colorScheme.primary )
            ),
          label: Text(lable),
        ),
      ),
    );
  }
} 




class BadgeScreen extends StatelessWidget {
   BadgeScreen({super.key,this.count=0});
  int count;
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: count>0,
      child: Container(
        alignment: Alignment.center,
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle
        ),
        child: Center(child: Text(count.toString(),style: const TextStyle(color: Colors.white,fontSize: 10),)),
      ));
  }
}