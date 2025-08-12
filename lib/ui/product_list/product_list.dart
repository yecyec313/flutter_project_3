import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/data/common/mixin.dart';
import 'package:flutter_ali_nike/data/repo/repository.dart';
import 'package:flutter_ali_nike/ui/product_list/bloc/product_list_bloc.dart';
import 'package:flutter_ali_nike/ui/products/details.dart';

import 'package:flutter_ali_nike/ui/widget/Items.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ProductList extends StatefulWidget {
  String searchTerm;
  int sort;

  String sortName;
  ProductList(
      {super.key,
      required this.sortName,
      this.searchTerm = "",
      required this.sort});
  ProductList.search(
      {super.key,
      required this.sortName,
      required this.searchTerm,
      required this.sort});

  @override
  State<ProductList> createState() => _ProductListState();
}

// ignore: camel_case_types
enum nazm {
  // ignore: constant_identifier_names
  tl,
  ol
}

class _ProductListState extends State<ProductList> {
  nazm nar = nazm.tl;
  ProductListBloc? bloc;
  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.searchTerm.isEmpty
            ? 'کفش های ورزشی'
            : "نتایج جستوجوی ${widget.searchTerm}"),
      ),
      body: SafeArea(
        child: BlocProvider<ProductListBloc>(
          create: (context) {
            bloc = ProductListBloc(repositoryP)
              ..add(ProductStarted(widget.sort, widget.searchTerm));

            return bloc!;
          },
          child: BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state is ProductListSuccess) {
                return Column(
                  children: [
                    widget.searchTerm.isEmpty
                        ? Container(
                            height: 56,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color:
                                            Theme.of(context).dividerColor))),
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: 300,
                                        padding: const EdgeInsets.only(
                                            top: 24, bottom: 24),
                                        child: Column(
                                          children: [
                                            Text(
                                              'انتخاب مرتب سازی',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge,
                                            ),
                                            Expanded(
                                                child: ListView.builder(
                                                    // padding: EdgeInsets.only(
                                                    //     left: 12, top: 8),
                                                    itemCount: SortName
                                                        .sortName.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      // if (index == 0) {
                                                      //   widget.sortName = "جدید ترین";
                                                      // } else if (index == 1) {
                                                      //   widget.sortName =
                                                      //       "پر بازدید ترین";
                                                      // } else if (index == 2) {
                                                      //   widget.sortName =
                                                      //       "قیمت نزولی";
                                                      // } else if (index == 3) {
                                                      //   widget.sortName ==
                                                      //       "قیمت صعودی";
                                                      // }
                                                      final sel = state.sort;
                                                      final textS = SortName
                                                          .sortName[index];
                                                      return SizedBox(
                                                        height: 38,
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (index != sel) {
                                                              widget.sort =
                                                                  index;
                                                              bloc!.add(
                                                                  ProductStarted(
                                                                      index,
                                                                      ""));
                                                              Navigator.pop(
                                                                  context);
                                                            }
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              children: [
                                                                Text(textS),
                                                                const SizedBox(
                                                                  width: 8,
                                                                ),
                                                                if (index ==
                                                                    sel)
                                                                  Icon(
                                                                    CupertinoIcons
                                                                        .check_mark_circled_solid,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                  )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }))
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // const Icon(
                                      //   CupertinoIcons.sort_down,
                                      // ),
                                      // SizedBox(
                                      //   width: 8,
                                      // ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            CupertinoIcons.sort_down,
                                            size: 30,
                                          )),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          const Text("مرتب سازی"),
                                          Text(
                                            SortName.sortName[state.sort],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                                  Container(
                                    width: 1,
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.2),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          nar = nar == nazm.tl
                                              ? nazm.ol
                                              : nazm.tl;
                                        });
                                      },
                                      icon: const Icon(
                                          CupertinoIcons.square_grid_2x2))
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.72,
                            crossAxisCount: nar == nazm.tl ? 2 : 1,
                          ),
                          itemCount: state.proD.length,
                          itemBuilder: (BuildContext context, int index) {
                            final prod = state.proD[index];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(product: prod)));
                                },
                                child: ProductItems(
                                  products: prod,
                                  borderRadius: null,
                                  height1: nar == nazm.tl ? 170 : null,
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                );
              } else if (state is ProductEmpty) {
                return Center(
                  child: Text(state.text1),
                );
              } else {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
