import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/data/common/exception.dart';
import 'package:flutter_ali_nike/data/common/extention.dart';
import 'package:flutter_ali_nike/data/repo/auth_repository.dart';
import 'package:flutter_ali_nike/data/repo/cart_repository.dart';
import 'package:flutter_ali_nike/data/source/Data/cart_data.dart';

import 'package:flutter_ali_nike/ui/cart/bloc/cart_bloc.dart';
import 'package:flutter_ali_nike/ui/cart/bloc/delete_bloc.dart';
import 'package:flutter_ali_nike/ui/login%20or%20sign%20up/auth.dart';
import 'package:flutter_ali_nike/ui/shipping/shipping.dart';
import 'package:flutter_ali_nike/ui/widget/sliderd.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int payble1 = 0;
  int ship1 = 0;
  int total1 = 0;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool isSuc = false;
  StreamSubscription? _statesub;
  final RefreshController _refreshController = RefreshController();
  CartBloc? cartBloc;
  @override
  void initState() {
    IAuthRepository.authChangeNotifier.addListener(authChangeListener);
    // cartBloc?.add(CartStarted(IAuthRepository.authChangeNotifier.value));
    super.initState();
  }
  // @override
  // void didChangeDependencies() {
  //   cartBloc?.add(CartStarted(IAuthRepository.authChangeNotifier.value));
  //   super.didChangeDependencies();
  // }

  void authChangeListener() {
    cartBloc
        ?.add(CartAuthDataChanged(IAuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    IAuthRepository.authChangeNotifier.removeListener(authChangeListener);
    // cartBloc?.stopRefresh();
    _statesub?.cancel();
    _scaffoldKey.currentState?.dispose();
    cartBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    repositoryCart.getAll().then((value) {
      debugPrint(value.toString());
    }).catchError((e) {
      debugPrint(e.toString());
    });

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ValueListenableBuilder(
          valueListenable: ICartRepository.conyChangeNotifier,
          builder: (context, value, child) {
            return SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: Visibility(
                visible: value,
                child: FloatingActionButton.extended(
                    backgroundColor: Colors.black,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShippingScreen(
                                paybel: payble1,
                                total: total1,
                                ship: ship1,
                              )));
                    },
                    label: const Text('پرداخت')),
              ),
            );
          },
        ),
        backgroundColor: const Color(0xfff5f5f5),
        appBar: AppBar(
          toolbarHeight: 50,
          centerTitle: true,
          title: const Text("سبد خرید"),
        ),
        body: BlocProvider<CartBloc>(
          create: (context) {
            alo = true;
            final bloc = CartBloc(repositoryCart);
            cartBloc = bloc;
            _statesub = bloc.stream.listen((state) {
              if (_refreshController.isRefresh) {
                if (state is CartSuccess || state is CartEmpty) {
                  // ignore: use_build_context_synchronously
                  _refreshController.refreshCompleted();
                } else if (state is CartError) {
                  _refreshController.refreshFailed();
                }
              } else if (state is CartSuccess) {
                if (StringA == 'A1') {
                  // setState(() {
                  //   isSuc = true;
                  // });
                  StringA = 'A2';
                  _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                      content: Text('محصول از سبد خرید حذف شد')));
                }
                //  else if (StringA == 'A3') {
                //   setState(() {
                //     isSuc = false;
                //   });
                // }
              } else if (state is CartError) {
                ICartRepository.conyChangeNotifier.value = false;
              }
              //  else if (StringA == 'A4') {
              //   setState(() {
              //     isSuc = true;
              //   });
              // }
              //  else if (state is CartEmpty && StringA == 'A1') {
              //   StringA = 'A2';
              //   ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('محصول از سبد خرید حذف شد')));
              // }
            });
            bloc.add(CartStarted(IAuthRepository.authChangeNotifier.value));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CartSuccess) {
              return ValueListenableBuilder(
                valueListenable: ICartRepository.conChangeNotifier,
                builder: (context, value, child) {
                  if (value.isEmpty) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/img/no_data.svg',
                            width: 120,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            'سبد خرید خالی است ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color:
                                        const Color.fromARGB(167, 19, 18, 18)),
                          )
                        ],
                      ),
                    );
                  } else {
                    return SmartRefresher(
                      header: const ClassicHeader(
                        refreshingIcon: CupertinoActivityIndicator(),
                        completeText: 'با موفقیت انجام شد',
                        refreshingText: 'در حال به روز رسانی',
                        idleText: 'برای به روز رسانی پایین بکشید',
                        releaseText: 'رها کنید',
                        failedText: 'خطای نامشخص',
                        spacing: 2,
                      ),
                      controller: _refreshController,
                      onRefresh: () {
                        cartBloc?.add(CartStarted(
                            IAuthRepository.authChangeNotifier.value,
                            isRefresh: true));
                      },
                      child: ListView.builder(
                          // physics: const BouncingScrollPhysics(
                          //     decelerationRate: ScrollDecelerationRate.normal
                          //     ),
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 8, bottom: 110),
                          scrollDirection: Axis.vertical,
                          itemCount: value.length + 1,
                          itemBuilder: (context, index) {
                            // final count = state.carts.cart_items;
                            // if (index == 0) {
                            //   return ElevatedButton(
                            //       onPressed: () {
                            //         repositoryAuth.signOut();
                            //         // BlocProvider.of<CartBloc>(context).add(CartStarted());
                            //       },
                            //       child: const Text('خروج از حساب'));
                            // }
                            if (index == value.length) {
                              int payble = 0;
                              int ship = 0;
                              int total = 0;
                              value.forEach((element) {
                                total += element.product.previousPrice *
                                    element.count;
                                payble += element.product.price * element.count;
                              });
                              ship = payble >= 250000 ? 0 : 30000;
                              payble1 = payble;
                              ship1 = ship;
                              total1 = total;
                              return PriceInfo(
                                  total: total, ship: ship, payble: payble);
                            } else {
                              final count = value[index];
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1))
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          CachedNetwork(
                                              imageUrl: count.product.imageUrl,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              height: 100),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                count.product.title,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, right: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'تعداد',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    // SizedBox(
                                                    //   width: 10,
                                                    // ),
                                                    count.loadCount == false
                                                        ? IconButton(
                                                            icon: const Icon(
                                                                CupertinoIcons
                                                                    .plus_rectangle),
                                                            onPressed: () {
                                                              cartBloc?.add(
                                                                  CartPlusButtonClick(
                                                                      count
                                                                          .id));
                                                            },
                                                          )
                                                        : const Icon(
                                                            CupertinoIcons
                                                                .plus_rectangle),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    count.loadCount == false
                                                        ? Text(count.count
                                                            .toString())
                                                        : const CupertinoActivityIndicator(),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    count.loadCount == false
                                                        ? IconButton(
                                                            icon: const Icon(
                                                                CupertinoIcons
                                                                    .minus_rectangle),
                                                            onPressed: () {
                                                              if (count.count >
                                                                  1) {
                                                                cartBloc?.add(
                                                                    CartMinusButtonClick(
                                                                        count
                                                                            .id));
                                                              }
                                                            },
                                                          )
                                                        : const Icon(
                                                            CupertinoIcons
                                                                .minus_rectangle)
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  count.product.previousPrice
                                                      .withPriceLabel,
                                                  style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                ),
                                                Text(count.product.price
                                                    .withPriceLabel)
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                      ),
                                      Center(
                                        child: count.load == false
                                            ? TextButton(
                                                onPressed: () async {
                                                  // ignore: unused_local_variable
                                                  cartBloc?.add(
                                                      CartDeleteButton(
                                                          count.id));
                                                  // if (StringA == 'A') {
                                                  //   ScaffoldMessenger.of(context)
                                                  //       .showSnackBar(const SnackBar(
                                                  //           content: Text('خطای نامشخص')));
                                                  // }

                                                  //  catch (e) {
                                                  //   ScaffoldMessenger.of(context)
                                                  //       .showSnackBar(SnackBar(
                                                  //           content: Text('خطای نامشخص')));
                                                  //   debugPrint(e.toString());
                                                  // }
                                                },
                                                child: const Text(
                                                    'حذف از سبد خرید'))
                                            : const CupertinoActivityIndicator(),
                                      )
                                      // DeleteScreen(
                                      //   count: count,
                                      //   state11: state,
                                      //   cartBloc: cartBloc,
                                      // )
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    );
                  }
                },
              );
            } else if (state is CartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(state.exception.message),
                    ElevatedButton(
                        onPressed: () {
                          // context.read<HomeBlocBloc>().add(HomeRefresh());
                          BlocProvider.of<CartBloc>(context).add(CartStarted(
                              IAuthRepository.authChangeNotifier.value));
                        },
                        child: const Text('تلاش دوباره')),
                  ],
                ),
              );
              // ValueListenableBuilder(
              //     valueListenable: IAuthRepository.authChangeNotifier,
              //     builder: (context, authState, child) {
              //       bool isAuthenticated =
              //           authState != null && authState.accessToken.isNotEmpty;
              //       return SizedBox(
              //         width: MediaQuery.of(context).size.width,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             Text(isAuthenticated
              //                 ? 'خطای نامشخص'
              //                 : 'لطفا وارد حساب کاربری خود شوید'),
              //             isAuthenticated
              //                 ? ElevatedButton(
              //                     onPressed: () {
              //                       BlocProvider.of<CartBloc>(context)
              //                           .add(CartStarted());
              //                       // repositoryAuth.signOut();
              //                     },
              //                     child: const Text('تلاش دوباره'))
              //                 : ElevatedButton(
              //                     onPressed: () async {
              //                       final res = await Navigator.of(context,
              //                               rootNavigator: true)
              //                           .push(MaterialPageRoute(
              //                         builder: (context) => const AuthScreen(),
              //                       ));
              //                       BlocProvider.of<CartBloc>(context)
              //                           .add(CartStarted());
              //                       // if (res != null) {
              //                       //   setState(() {});
              //                       // }
              //                       // Navigator.of(context).push(
              //                       //     MaterialPageRoute(
              //                       //         builder: (context) =>
              //                       //             CartScreen()));
              //                     },
              //                     child: const Text('ورود')),
              //             // ElevatedButton(
              //             //     onPressed: () async {
              //             //       await repositoryAuth.refreshToken();
              //             //       debugPrint(authState!.refreshToken.toString());
              //             //     },
              //             //     child: const Text('Refresh Token')),
              //           ],
              //         ),
              //       );
              //     });
            } else if (state is CartAuthRequired) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لطفا وارد حساب کاربری خود شوید'),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AuthScreen()));
                        },
                        child: const Text('ورود یا ثبت نام'))
                  ],
                ),
              );
            }
            // else if (state is CartEmpty) {
            //   return SizedBox(
            //     width: MediaQuery.of(context).size.width,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         SvgPicture.asset(
            //           'assets/img/no_data.svg',
            //           width: 120,
            //         ),
            //         SizedBox(
            //           height: 12,
            //         ),
            //         Text(
            //           'سبد خرید خالی است ',
            //           style: Theme.of(context)
            //               .textTheme
            //               .titleLarge!
            //               .copyWith(color: const Color.fromARGB(167, 19, 18, 18)),
            //         )
            //       ],
            //     ),
            //   );
            // }
            else {
              throw Exception('state is not supported');
            }
          }),
        ),
        // ValueListenableBuilder(
        //     valueListenable: IAuthRepository.authChangeNotifier,
        //     builder: (context, authState, child) {
        //       bool isAuthenticated =
        //           authState != null && authState.accessToken.isNotEmpty;
        //       return SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Text(isAuthenticated
        //                 ? 'خوش آمدید'
        //                 : 'لطفا وارد حساب کاربری خود شوید'),
        //             isAuthenticated
        //                 ? ElevatedButton(
        //                     onPressed: () {
        //                       repositoryAuth.signOut();
        //                     },
        //                     child: const Text('خروج از حساب'))
        //                 : ElevatedButton(
        //                     onPressed: () {
        //                       Navigator.of(context, rootNavigator: true).push(
        //                           MaterialPageRoute(
        //                               builder: (context) =>
        //                                   const AuthScreen()));
        //                     },
        //                     child: const Text('ورود')),
        //             ElevatedButton(
        //                 onPressed: () async {
        //                   await repositoryAuth.refreshToken();
        //                   debugPrint(authState!.refreshToken.toString());
        //                 },
        //                 child: const Text('Refresh Token')),
        //           ],
        //         ),
        //       );
        //     }),
      ),
    );
  }
}

class PriceInfo extends StatelessWidget {
  const PriceInfo({
    super.key,
    required this.total,
    required this.ship,
    required this.payble,
  });

  final int total;
  final int ship;
  final int payble;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            "جزءیات خرید",
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(fontWeightDelta: 3, fontSizeDelta: 2),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
          margin: const EdgeInsets.fromLTRB(4, 8, 4, 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 10,
                  color: Color(
                    0xfff5f5f5,
                  ),
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ کل خرید'),
                    RichText(
                      text: TextSpan(
                          text: total.jodaBcomma,
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontWeight: FontWeight.bold),
                          children: const [
                            TextSpan(
                                text: ' تومان',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal))
                          ]),
                    )
                  ],
                ),
              ),
              const Divider(
                height: 1.3,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("هزینه ارسال"),
                    Text(ship.withPriceLabel)
                  ],
                ),
              ),
              const Divider(
                height: 1.3,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلق قابل پرداخت'),
                    RichText(
                      text: TextSpan(
                          text: payble.jodaBcomma,
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontWeight: FontWeight.bold),
                          children: const [
                            TextSpan(
                                text: ' تومان',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal))
                          ]),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class DeleteScreen extends StatefulWidget {
  const DeleteScreen(
      {super.key,
      required this.count,
      required this.state11,
      required this.cartBloc});
  final CartSuccess state11;
  final CartItemData count;
  final CartBloc? cartBloc;

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  StreamSubscription<DeleteState>? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeleteBloc>(
      create: (context) {
        final bloc = DeleteBloc(repositoryCart);

        streamSubscription = bloc.stream.listen((state) {
          if (state is Error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.exception.message)));
          } else if (state is CartSuccessS) {
            widget.cartBloc
                ?.add(CartStarted(IAuthRepository.authChangeNotifier.value));
          } else {
            debugPrint('state is not supported');
          }
        });

        return bloc;
      },
      child: BlocBuilder<DeleteBloc, DeleteState>(
        builder: (context, state) {
          return Center(
            child: TextButton(
                onPressed: () {
                  // state1 = widget.state11;
                  // cartBloc?.add(
                  //     CartDeleteButton(count.id));
                  BlocProvider.of<DeleteBloc>(context)
                      .add(Delete(widget.count.id));
                },
                child: state is! CartLoad
                    ? const Text('حذف از سبد خرید')
                    : const CupertinoActivityIndicator()),
          );
        },
      ),
    );
  }
}
