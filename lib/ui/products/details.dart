import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/Theme.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';

import 'package:flutter_ali_nike/data/common/extention.dart';

import 'package:flutter_ali_nike/data/repo/cart_repository.dart';
import 'package:flutter_ali_nike/data/repo/repository_comment.dart';
import 'package:flutter_ali_nike/data/source/Data/product.dart';
import 'package:flutter_ali_nike/ui/cart/bloc/cart_bloc.dart';

import 'package:flutter_ali_nike/ui/products/Comments/comments.dart';
import 'package:flutter_ali_nike/ui/products/bloc/insert_bloc.dart';

import 'package:flutter_ali_nike/ui/widget/sliderd.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsScreen extends StatefulWidget {
  final ProductData product;

  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  StreamSubscription<CartState>? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {});
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider<CartBloc>(
          create: (context) {
            final bloc = CartBloc(repositoryCart);
            streamSubscription = bloc.stream.listen((state) {
              if (state is ProductAddToCartSuccess) {
                alo = false;
                _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                    content: Text('محصول با موفقیت به سبد خرید اضافه شد')));
              } else if (state is ProductAddToCartError) {
                _scaffoldKey.currentState?.showSnackBar(
                    SnackBar(content: Text(state.exception.message)));
              }
            });
            return bloc;
          },
          child: ScaffoldMessenger(
            key: _scaffoldKey,
            child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    return FloatingActionButton.extended(
                        backgroundColor: Colors.black,
                        onPressed: () async {
                          BlocProvider.of<CartBloc>(context).add(
                              AddToCartIsButtonClick(
                                  productId: widget.product.id));
                          // BlocProvider.of<CartBloc>(context).add(CartStarted(
                          //     IAuthRepository.authChangeNotifier.value));
                        },
                        label: state is ProductAddToCartLoading
                            ? const CupertinoActivityIndicator(
                                color: Colors.white,
                              )
                            : const Text('افزودن به سبد خرید'));
                  },
                ),
              ),
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    foregroundColor: LightThemeColor.primaryTextColor,
                    expandedHeight: MediaQuery.of(context).size.width * 0.8,
                    flexibleSpace: CachedNetwork(
                      imageUrl: widget.product.imageUrl,
                      borderRadius: null,
                      height: null,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.product.title),
                              Column(
                                children: [
                                  Text(
                                    widget.product.price.withPriceLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(
                                            decoration:
                                                TextDecoration.lineThrough),
                                  ),
                                  Text(widget
                                      .product.previousPrice.withPriceLabel),
                                ],
                              )
                            ],
                          ),
                          const Text(
                            'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا. هیچ فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود',
                            style: TextStyle(height: 1.4),
                          ),
                          const SizedBox(
                            height: 23,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'نظرات کاربران',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        useRootNavigator: true,
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: BottomSheet(
                                              productId: widget.product.id,
                                              scaffoldState:
                                                  _scaffoldKey.currentState,
                                            ),
                                          );
                                        });
                                  },
                                  child: Text(
                                    'ثبت نظر',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.blue),
                                  ))
                            ],
                          ),

                          // Container(
                          //   color: Colors.blue,
                          //   height: 1000,
                          //   width: 300,
                          // )
                        ],
                      ),
                    ),
                  ),
                  CommentsList(id: widget.product.id),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 70,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class BottomSheet extends StatefulWidget {
  final ScaffoldMessengerState? scaffoldState;
  final int productId;
  const BottomSheet({
    super.key,
    required this.productId,
    this.scaffoldState,
  });

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  @override
  void dispose() {
    subscription?.cancel();

    super.dispose();
  }

  StreamSubscription? subscription;

  final TextEditingController _controllerE = TextEditingController();
  final TextEditingController _controllerM = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) {
        final bloc = InsertBloc(commentsRepository, widget.productId);
        subscription = bloc.stream.listen((state) {
          if (state is InsertError) {
            widget.scaffoldState?.showSnackBar(
                SnackBar(content: Text(state.exception.message)));
            Navigator.of(context, rootNavigator: true).pop();
          } else if (state is InsertSuccess) {
            widget.scaffoldState
                ?.showSnackBar(SnackBar(content: Text(state.massage)));
            Navigator.of(context, rootNavigator: true).pop();
          }
        });
        return bloc;
      },
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<InsertBloc, InsertState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "ثبت نظر",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _controllerE,
                      decoration: InputDecoration(
                          label: Text(
                        "عنوان",
                        style:
                            theme.textTheme.bodySmall!.apply(fontSizeDelta: 3),
                      )),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: _controllerM,
                      decoration: InputDecoration(
                          label: Text(
                        "متن نظر خود را وارد کنید",
                        style:
                            theme.textTheme.bodySmall!.apply(fontSizeDelta: 3),
                      )),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.blue),
                            minimumSize: WidgetStatePropertyAll(
                              Size.fromHeight(56),
                            )),
                        onPressed: () {
                          context.read<InsertBloc>().add(SaveInsertClicked(
                              _controllerE.text, _controllerM.text));
                        },
                        child: state is InsertLoading
                            ? CupertinoActivityIndicator(
                                color: theme.colorScheme.onPrimary,
                              )
                            : Text(
                                "ذخیره",
                                style: theme.textTheme.bodyMedium!.apply(
                                    fontSizeDelta: 3, color: Colors.white),
                              ))
                  ],
                ),
              );
            },
          )),
    );
  }
}
