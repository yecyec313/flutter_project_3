import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ali_nike/data/source/Data/banner.dart';
// import 'package:flutter_ali_nike/ui/widget/image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderD extends StatelessWidget {
  final PageController _controllerq = PageController();
  final List<BannerData1> banners;
  SliderD({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 2,
        child: Stack(
          children: [
            PageView.builder(
                controller: _controllerq,
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/img/${banner.imageUrl}')
                      //  CachedNetwork(
                      //   imageUrl: banners[index].imageUrl,
                      // ),
                      );
                }),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _controllerq,
                    count: banners.length,
                    axisDirection: Axis.horizontal,
                    effect: WormEffect(
                        spacing: 4.0,
                        radius: 4.0,
                        dotWidth: 20.0,
                        dotHeight: 2.0,
                        paintStyle: PaintingStyle.fill,
                        dotColor: Colors.grey.shade400,
                        activeDotColor: Colors.pink),
                  ),
                ))
          ],
        ));
  }
}

// ignore: must_be_immutable
class CachedNetwork extends StatelessWidget {
  final BorderRadius? borderRadius;
  final double? height;
  final String imageUrl;
  const CachedNetwork({
    super.key,
    required this.imageUrl,
    required this.borderRadius,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      height: height,
      fit: BoxFit.cover, imageUrl: imageUrl,
      //  fadeInDuration: Duration.zero
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    } else {
      return image;
    }
  }
}
