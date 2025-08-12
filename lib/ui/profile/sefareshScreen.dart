import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/data/common/extention.dart';
import 'package:flutter_ali_nike/data/repo/shipping_repository.dart';
import 'package:flutter_ali_nike/ui/profile/bloc/order_bloc.dart';
import 'package:flutter_ali_nike/ui/widget/sliderd.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>(
      create: (context) => OrderBloc(repositoryShip)..add(OrderStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("سوابق سفارش"),
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.orderData.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = state.orderData[index];
                  return Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("شناسه سفارش"),
                              Text(order.id.toString())
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("مبلغ"),
                              Text(order.payable.withPriceLabel),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        SizedBox(
                          height: 132,
                          child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              scrollDirection: Axis.horizontal,
                              itemCount: order.order.length,
                              itemBuilder: (context, index) {
                                // if (order.order.isEmpty) {
                                //   return const Padding(
                                //     padding: EdgeInsets.all(8.0),
                                //     child: Text("سوابق سفارش خالی است"),
                                //   );
                                // }
                                // else {
                                return Container(
                                  margin: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  width: 100,
                                  height: 100,
                                  child: CachedNetwork(
                                      imageUrl: order.order[index].imageUrl,
                                      borderRadius: BorderRadius.circular(8),
                                      height: null),
                                );
                                // }
                              }),
                        )
                      ],
                    ),
                  );
                },
              );
            } else if (state is OrderLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is OrderError) {
              return Center(child: Text(state.exception.message));
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
