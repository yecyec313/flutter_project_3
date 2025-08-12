import 'package:dio/dio.dart';
import 'package:flutter_ali_nike/data/common/mixin.dart';
import 'package:flutter_ali_nike/data/source/Data/banner.dart';

abstract class BannerDataSource {
  Future<List<BannerData>> getAll();
}

class BannerRemote with HttpResponseValidator implements BannerDataSource {
  final Dio httpClient;

  BannerRemote(this.httpClient);
  @override
  Future<List<BannerData>> getAll() async {
    final response = await httpClient.get('banner/slider');
    validateResponse(response);
    final List<BannerData> banners = [];
    for (var jsonObject in (response.data as List)) {
      banners.add(BannerData.fromJson(jsonObject));
    }
    return banners;
  }
}
