import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store_flutter/common/utils.dart';
import 'package:nike_store_flutter/data/models/banner.dart';
import 'package:nike_store_flutter/data/models/product.dart';
import 'package:nike_store_flutter/data/repo/banner_repo.dart';
import 'package:nike_store_flutter/data/repo/product_repo.dart';
import 'package:nike_store_flutter/gen/assets.gen.dart';
import 'package:nike_store_flutter/ui/home/bloc/home_bloc.dart';
import 'package:nike_store_flutter/ui/product/product.dart';
import 'package:nike_store_flutter/ui/product_list/product_list.dart';
import 'package:nike_store_flutter/ui/widgets/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(
            banner: bannerRepository,
            productLatest: productRepository,
            productPopular: productRepository);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HomeSuccess) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Assets.images.nikeLogo.image(height: 32,color: theme.colorScheme.primary));
                      case 2:
                        return SizedBox(
                          height: 200,
                          child: Slider(
                            banner: state.banner,
                          ),
                        );

                      case 3:
                        return productListWidget(
                          title: "جدیدترین",
                          product: state.productLatest,
                        );
                        case 4:
                        return Container(margin: const EdgeInsets.symmetric(vertical: 16),child: productListWidget(product: state.productPopular, title: 'پربازدید ترین'));
                      default:
                        return Container();
                    }
                  },
                );
              } else if (state is HomeError) {
                return Errorwidget(message:  'تلاش مجدد',onTap:(){
                  BlocProvider.of<HomeBloc>(context).add(HomeRefreshing());
                  
                });
              } else {
                throw Exception('state is not started');
              }
            },
          ),
        ),
      ),
    );
  }
}

class productListWidget extends StatelessWidget {
  final List<ProductEntity> product;
  final String title;
  const productListWidget({
    Key? key,
    required this.product,required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2,
              ),
              TextButton(
                onPressed: () {
                  if(title=='جدیدترین'){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return ProductListScreen(productEntity: product,sort: ProductSort.latest,);
                      }));
                  }else{
                       Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return ProductListScreen(productEntity: product,sort: ProductSort.popular,);
                      }));
                  }
                },
                child: Text('موارد بیشتر',
                    ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 370,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: product.length,
              itemBuilder: (context, indext) {
                final productItem = product[indext];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 200,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(builder: ((context) =>
                      //  ProductDetailsScreen(product: productItem,) )));

                      Navigator.of(context).push(PageRouteBuilder(pageBuilder: ((context, animation, secondaryAnimation) {
                        return ProductDetailsScreen(product: productItem);
                      }),transitionDuration: const Duration(milliseconds: 375)));
                    },
                    child: ProductWidget(productItem: productItem,borderRadius: BorderRadius.circular(16),)),
                );
              }),
        ),
      ],
    );
  }
}

class Slider extends StatelessWidget {
  final List<BannerEntity> banner;
  final PageController _pagecontroller = PageController();
  Slider({Key? key, required this.banner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          physics: const BouncingScrollPhysics(),
            itemCount: banner.length,
            controller: _pagecontroller,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ImageLoader(imageurl: banner[index].imageurl)),
              );
            }),
        Positioned(
          left: 0,
          right: 0,
          bottom: 8,
          child: Center(
            child: SmoothPageIndicator(
              controller: _pagecontroller,
              count: banner.length,
              axisDirection: Axis.horizontal,
              effect: WormEffect(
                  spacing: 8.0,
                  radius: 4.0,
                  dotWidth: 24.0,
                  dotHeight: 3.0,
                  strokeWidth: 1.5,
                  dotColor:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                  activeDotColor: Theme.of(context).colorScheme.primary),
            ),
          ),
        )
      ],
    );
  }
}
