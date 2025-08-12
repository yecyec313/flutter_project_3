// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/Theme.dart';
import 'package:flutter_ali_nike/data/repo/shipping_repository.dart';
import 'package:flutter_ali_nike/data/source/Data/shipping.dart';
import 'package:flutter_ali_nike/ui/cart/cart.dart';
import 'package:flutter_ali_nike/ui/reciept/payment.dart';
import 'package:flutter_ali_nike/ui/shipping/bloc/shipping_bloc.dart';
import 'package:flutter_ali_nike/ui/widget/paymentwidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen(
      {super.key,
      required this.paybel,
      required this.total,
      required this.ship});
  final int paybel;
  final int total;
  final int ship;

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController controllerF =
      TextEditingController(text: "saeed");
  final TextEditingController controllerL =
      TextEditingController(text: "sasad");
  final TextEditingController controllerP =
      TextEditingController(text: "1234567890");
  final TextEditingController controllerM =
      TextEditingController(text: "09378122153");
  final TextEditingController controllerA =
      TextEditingController(text: "asasdasdasdzxczxczxgasewrwerwerwerwerwer");

  StreamSubscription? subscription;
  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده '),
        centerTitle: true,
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(repositoryShip);
          subscription = bloc.stream.listen((state) {
            if (state is ShippingSuccess) {
              if (state.result.bank.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PaymentOnlineScreen(bank: state.result.bank)));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                              orderId: state.result.orderId,
                            )));
              }
            } else if (state is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });

          return bloc;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: controllerF,
                  decoration: const InputDecoration(label: Text('نام')),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: controllerL,
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                      // counterText: "lkjl",
                      // counterStyle: TextStyle(color: Colors.amber),
                      // labelText: "نام و نام خانوادگی",
                      // hintStyle: TextStyle(
                      //     color: const Color.fromARGB(255, 255, 0, 149)
                      //         .withOpacity(0.1)),

                      // labelStyle:
                      //     TextStyle(color: LightThemeColor.secondaryTextColor),
                      label: const Text("نام خانوادگی")),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: controllerM,
                  decoration: const InputDecoration(label: Text('شماره تماس')),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: controllerP,
                  decoration: const InputDecoration(label: Text("کدپستی")),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: controllerA,
                  decoration: const InputDecoration(label: Text("آدرس")),
                ),
                const SizedBox(
                  height: 12,
                ),
                PriceInfo(
                    total: widget.total,
                    ship: widget.ship,
                    payble: widget.paybel),
                const SizedBox(
                  height: 14,
                ),
                BlocBuilder<ShippingBloc, ShippingState>(
                  builder: (context, state) {
                    if (state is ShippingLoading) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  textStyle: WidgetStateProperty.all(
                                      const TextStyle(color: Colors.white)),
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.blue)),
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                    shippingPaymentClicked(DataShipping(
                                        controllerF.text,
                                        controllerL.text,
                                        controllerP.text,
                                        controllerM.text.toString(),
                                        controllerA.text,
                                        nupardakht.online)));
                              },
                              child: const Text(
                                'پرداخت اینترنتی',
                                style: TextStyle(color: Colors.white),
                              )),
                          const SizedBox(
                            width: 16,
                          ),
                          OutlinedButton(
                              style: ButtonStyle(
                                  side: WidgetStateProperty.all(BorderSide(
                                      color: LightThemeColor.primaryTextColor
                                          .withOpacity(0.1)))),
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                    shippingPaymentClicked(DataShipping(
                                        controllerF.text,
                                        controllerL.text,
                                        controllerP.text,
                                        controllerM.text.toString(),
                                        controllerA.text,
                                        nupardakht.mahaly)));
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         const PaymentScreen()));
                              },
                              child: const Text("پرداخت در محل"))
                        ],
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
