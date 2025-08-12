import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/Theme.dart';
import 'package:flutter_ali_nike/data/common/extention.dart';
import 'package:flutter_ali_nike/data/repo/shipping_repository.dart';
import 'package:flutter_ali_nike/ui/reciept/bloc/payment_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentScreen extends StatelessWidget {
  final int orderId;
  const PaymentScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('رسید پرداخت'),
        centerTitle: true,
      ),
      body: BlocProvider<PaymentBloc>(
        create: (context) =>
            PaymentBloc(repositoryShip)..add(PaymentStarted(orderId)),
        child: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            if (state is PaymentError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else if (state is PaymentLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is PaymentSuccess) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        border: Border.all(color: theme.dividerColor, width: 1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.checkOutShipping.purchase
                              ? 'پرداخت با موفقیت انجام شد'
                              : "پرداخت ناموفق",
                          style: theme.textTheme.titleLarge!
                              .apply(color: LightThemeColor.primaryColor),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'وضعیت سفارش',
                              style: TextStyle(
                                color: LightThemeColor.secondaryTextColor,
                              ),
                            ),
                            Text(
                              state.checkOutShipping.payment,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const Divider(
                          height: 32,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "مبلغ",
                              style: TextStyle(
                                color: LightThemeColor.secondaryTextColor,
                              ),
                            ),
                            Text(
                              state.checkOutShipping.payble.withPriceLabel,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.blueAccent),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text(
                        'بازگشت به صفحه اصلی',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Avenir",
                            fontWeight: FontWeight.normal),
                      ))
                ],
              );
            } else {
              throw Exception('state is not supported');
            }
          },
        ),
      ),
    );
  }
}
