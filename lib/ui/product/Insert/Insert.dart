import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/data/repo/comment_repository.dart';
import 'package:nike_ecommerce_flutter/ui/product/Insert/bloc/insert_bloc.dart';

class ButtomSheet extends StatefulWidget {
  final ScaffoldMessengerState? scaffoldState;
  final int productId;
  const ButtomSheet({
    super.key,
    required this.productId,
    this.scaffoldState,
  });

  @override
  State<ButtomSheet> createState() => _ButtomSheetState();
}

class _ButtomSheetState extends State<ButtomSheet> {
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
        final bloc = InsertBloc(commentRepository, widget.productId);
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
                    const SizedBox(
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
