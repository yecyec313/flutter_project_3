import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/data/common/extention.dart';
import 'package:flutter_ali_nike/data/source/Data/product.dart';
import 'package:flutter_ali_nike/data/source/Data_Source/hive_managger.dart';
import 'package:flutter_ali_nike/ui/widget/sliderd.dart';

// ignore: must_be_immutable
class ProductItems extends StatelessWidget {
  double? height1;
  BorderRadius? borderRadius;
  ProductItems(
      {super.key, required this.products, this.borderRadius, this.height1});

  final ProductData products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            CachedNetwork(
              imageUrl: products.imageUrl,
              borderRadius: borderRadius,
              height: height1,
            ),
            Positioned(
              right: 8,
              top: 8,
              child: ValueListenableBuilder(
                  valueListenable: favoriteManagger.Listenable,
                  builder: (context, value, index) {
                    return Heart(
                      pro: products,
                    );
                  }),
              //      Icon(
              //   CupertinoIcons.heart,
              //   size: 22,
              // )
            )
          ]),
          Text(
            products.title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .apply(color: Colors.black),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            products.price.withPriceLabel,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .apply(decoration: TextDecoration.lineThrough),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(products.previousPrice.withPriceLabel)
        ],
      ),
    );
  }
}

class Heart extends StatefulWidget {
  final ProductData pro;
  const Heart({
    super.key,
    required this.pro,
  });

  @override
  State<Heart> createState() => _HeartState();
}

class _HeartState extends State<Heart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: IconButton(
          onPressed: () {
            if (favoriteManagger.isFavorite(widget.pro)) {
              favoriteManagger.delete(widget.pro);
            } else {
              favoriteManagger.addFavorite(widget.pro);
            }
            setState(() {});
          },
          icon: Icon(
              favoriteManagger.isFavorite(widget.pro)
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.heart,
              size: 20)),
    );
  }
}
