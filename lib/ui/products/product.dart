import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/Theme.dart';

import 'package:flutter_ali_nike/data/source/Data/product.dart';
import 'package:flutter_ali_nike/ui/product_list/product_list.dart';
import 'package:flutter_ali_nike/ui/products/details.dart';
import 'package:flutter_ali_nike/ui/widget/Items.dart';

// ignore: camel_case_types
class commona extends StatelessWidget {
  final int sort;
  final String title;
  final Function() ontap;
  final List<ProductData> products;
  const commona({
    super.key,
    required this.products,
    required this.title,
    required this.ontap,
    required this.sort,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductList(
                              sortName: title,
                              sort: sort,
                            )));
                  },
                  child: const Text(
                    'مشاهده همه',
                    style: TextStyle(color: LightThemeColor.primaryColor),
                  )),
              Text(
                title,
                style:
                    const TextStyle(color: LightThemeColor.secondaryTextColor),
              )
            ],
          ),
        ),
        // SizedBox(
        //   height: 20,
        // ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 270,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemCount: products.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                              product: products[index],
                            ))),
                    child: ProductItems(
                      products: products[index],
                      borderRadius: BorderRadius.circular(12),
                      height1: 170,
                    ),
                  ),
                );
              }
              //  Column(
              //       children: [
              //         CachedNetwork(imageUrl: products[index].imageUrl),
              //       ],
              //     )
              ),
        ),
      ],
    );
  }
}
