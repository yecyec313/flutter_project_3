import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/Theme.dart';
import 'package:flutter_ali_nike/ui/product_list/product_list.dart';

import 'package:flutter_ali_nike/ui/products/product.dart';
import 'package:flutter_ali_nike/data/repo/repository.dart';
import 'package:flutter_ali_nike/data/repo/repositoryBanner.dart';
import 'package:flutter_ali_nike/data/source/Data/banner.dart';

import 'package:flutter_ali_nike/ui/home/bloc/home_bloc_bloc.dart';
import 'package:flutter_ali_nike/ui/widget/sliderd.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController? controllerS = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBlocBloc(bannerRepository, repositoryP);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(child:
            BlocBuilder<HomeBlocBloc, HomeBlocState>(builder: (context, state) {
          if (state is HomeSuccess) {
            return ListView.builder(
                itemCount: 5,
                // padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                itemBuilder: (context, index) {
                  final posts = AppDataBase.posts;
                  switch (index) {
                    case 0:
                      return Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 54,
                            child: Image.asset(
                              'assets/img/nike_logo.png',
                              height: 26,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, bottom: 10, right: 12, top: 12),
                            child: TextField(
                              onSubmitted: (value) {
                                if (controllerS!.text.isNotEmpty) {
                                  _search(context);
                                }
                              },
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontFamily: "IranYekan", fontSize: 16),
                              textInputAction: TextInputAction.search,
                              controller: controllerS,
                              decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          width: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color:
                                            LightThemeColor.secondaryTextColor,
                                        width: 1,
                                      )),
                                  isCollapsed: false,
                                  label: Text("Search"),
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .apply(fontSizeDelta: 5),
                                  prefixIcon: IconButton(
                                    icon: Icon(CupertinoIcons.search),
                                    onPressed: () {
                                      if (controllerS!.text.isNotEmpty) {
                                        _search(context);
                                      }
                                    },
                                  )),
                            ),
                          )
                        ],
                      );
                    case 2:
                      return SliderD(banners: posts);
                    case 3:
                      return commona(
                        ontap: () {},
                        title: 'جدید ترین',
                        products: state.productLeates,
                        sort: 0,
                      );
                    case 4:
                      return commona(
                        ontap: () {},
                        title: 'پر بازدید ترین',
                        products: state.productPupolar,
                        sort: 1,
                      );
                    default:
                      return Container();
                  }
                });
          } else if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(state.exception.message),
                  ElevatedButton(
                      onPressed: () {
                        // context.read<HomeBlocBloc>().add(HomeRefresh());
                        BlocProvider.of<HomeBlocBloc>(context)
                            .add(HomeRefresh());
                      },
                      child: const Text('تلاش دوباره')),
                ],
              ),
            );
          } else {
            throw Exception('state is not supported');
          }
        })),
      ),
    );
  }

  void _search(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductList.search(
            sortName: "", searchTerm: controllerS!.text, sort: 0)));
  }
}
