import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/data/common/extention.dart';

import 'package:flutter_ali_nike/data/source/Data_Source/hive_managger.dart';
import 'package:flutter_ali_nike/ui/products/details.dart';
import 'package:flutter_ali_nike/ui/widget/sliderd.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("لیست علاقه مندی ها "),
        ),
        body: ValueListenableBuilder(
            valueListenable: favoriteManagger.Listenable,
            builder: (context, box, index) {
              final boss = box.values.toList();
              return ListView.builder(
                itemCount: boss.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DetailsScreen(product: boss[index])));
                    },
                    onLongPress: () {
                      favoriteManagger.delete(boss[index]);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 110,
                            height: 110,
                            child: CachedNetwork(
                                imageUrl: boss[index].imageUrl,
                                borderRadius: BorderRadius.circular(8),
                                height: null),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  boss[index].title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .apply(color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  boss[index].price.withPriceLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .apply(
                                          decoration:
                                              TextDecoration.lineThrough),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(boss[index].previousPrice.withPriceLabel)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
