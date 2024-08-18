import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_store_flutter/common/exception.dart';
import 'package:nike_store_flutter/common/utils.dart';
import 'package:nike_store_flutter/data/local/hive.dart';
import 'package:nike_store_flutter/data/models/product.dart';
import 'package:nike_store_flutter/data/repo/cart_repo.dart';
import 'package:nike_store_flutter/data/repo/comment_repo.dart';
import 'package:nike_store_flutter/ui/home/home.dart';
import 'package:nike_store_flutter/ui/product/bloc/comment_bloc.dart';
import 'package:nike_store_flutter/ui/product/bloc/product_bloc.dart';
import 'package:nike_store_flutter/ui/widgets/widgets.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductEntity product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ScrollController _scrollController;
  bool _finishScroll = true;
  bool _showTitle = false;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerState = GlobalKey();

  @override
  void dispose() {
    _scaffoldMessengerState.currentState?.dispose();
    super.dispose();
  }

  late LocalHiveDataBase localHiveDataBase;

  @override
  void initState() {
    _scrollController = ScrollController();
    localHiveDataBase = LocalHiveDataBase();
    _scrollController.addListener(() {
      if (_scrollController.offset > 244) {
        setState(() {
          _finishScroll = false;
          _showTitle = true;
        });
      } else if (_scrollController.offset < 244 && _finishScroll == false) {
        setState(() {
          _finishScroll = true;
          _showTitle = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) {
        final productBloc = ProductBloc(cartRepository);
        productBloc.stream.forEach((state) {
          if (state is ProductSuccessState) {
            _scaffoldMessengerState.currentState!.showSnackBar(SnackBar(
              content: Text('با موفقیت به سبد خرید افزوده شد'),
            ));
          } else if (state is ProductErrorState) {
            _scaffoldMessengerState.currentState!.showSnackBar(SnackBar(
              content: Text(state.message.message),
            ));
          }
        });
        return productBloc;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ScaffoldMessenger(
          key: _scaffoldMessengerState,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: FloatingActionButton.extended(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(PruductAddToCartClickEvent(widget.product.id));
                    },
                    label: state is ProductLoadingState
                        ? CupertinoActivityIndicator(
                            color: Colors.white,
                          )
                        : Text('افزودن به سبد خرید',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary))),
              );
            }),
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: theme.colorScheme.background,
                  actionsIconTheme:
                      IconThemeData(color: theme.colorScheme.primary),
                      iconTheme: IconThemeData(color:!_finishScroll? theme.colorScheme.onBackground : theme.colorScheme.primary ),
                  title: !_finishScroll
                      ? Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                      width: 1.2, color: Colors.white)),
                              child: ImageLoader(
                                  imageurl: widget.product.imageUrl),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                widget.product.title,
                                overflow: TextOverflow.ellipsis,
                                style:  TextStyle(color: theme.colorScheme.onBackground, fontSize: 12),
                              ),
                            )
                          ],
                        )
                      : null,
                  actions: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            if (localHiveDataBase
                                .isFavorite(widget.product.id)) {
                              localHiveDataBase
                                  .deleteFavorite(widget.product.id);
                            } else {
                              localHiveDataBase.addFavorite(widget.product);
                            }
                          });
                        },
                        child: Icon(
                            localHiveDataBase.isFavorite(widget.product.id)
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart)),
                    SizedBox(
                      width: 16,
                    )
                  ],
                  expandedHeight: 300,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  pinned: true,
                  flexibleSpace: !_finishScroll
                      ? null
                      : ImageLoader(imageurl: widget.product.imageUrl),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.title,
                                style: theme.textTheme.headline6!
                                    .copyWith(fontSize: 15.5),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.product.perviousPrice.withPricelable,
                                  style: theme.textTheme.caption!.copyWith(
                                      decoration: TextDecoration.lineThrough),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  widget.product.price.withPricelable,
                                  style: theme.textTheme.bodyText2,
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'ایمالز جستجو گر کالا و فروشگاه اینترنتی است که خریداران را به فروشندگان متصل و فرایند خرید را ساده می نماید و با به وجود آوردن یک فضای رقابتی به خریدار کمک میکند کالا ها را با قیمت ارزان تر خریداری کرده و همچنین تمام انتخاب های خود را در یکجا مشاهده می کند و این امر باعث خرید بهتر و ارزانتر و آگاهی از قیمت واقعی اجناس می شود.',
                          style:
                              theme.textTheme.bodyText2!.copyWith(height: 1.5),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نظرات کاربران',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'موارد بیشتر',
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                CommentWidget(productId: widget.product.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final productId;

  const CommentWidget({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(create: ((context) {
      final commentBloc =
          CommentBloc(commentRepository: commentRepo, productId: productId);
      commentBloc.add(CommentStarted());
      return commentBloc;
    }), child: BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentLoading) {
          return SliverToBoxAdapter(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        } else if (state is CommentSuccess) {
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final comment = state.comments[index];
              return Container(
                padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                margin: EdgeInsets.fromLTRB(
                    0, 0, 0, index == state.comments.length - 1 ? 100 : 0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: theme.colorScheme.secondary
                                .withOpacity(0.35)))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(comment.title),
                            Text(
                              comment.author.email,
                              style: theme.textTheme.caption,
                            ),
                          ],
                        ),
                        Text(
                          comment.date,
                          style: theme.textTheme.caption,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      comment.content,
                      style: theme.textTheme.bodyText2,
                    ),
                  ],
                ),
              );
            }, childCount: state.comments.length),
          );
        } else if (state is CommentError) {
          return SliverToBoxAdapter(
              child: Errorwidget(
                  message: ' تلاش مجدد برای دریافت کامنت',
                  onTap: (() => BlocProvider.of<CommentBloc>(context)
                      .add(CommentRefreshing()))));
        } else {
          throw AppException(message: 'state has note event');
        }
      },
    ));
  }
}
