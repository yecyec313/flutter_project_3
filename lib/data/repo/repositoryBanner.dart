// ignore: file_names
import 'package:flutter_ali_nike/data/common/http.dart';
import 'package:flutter_ali_nike/data/source/Data/banner.dart';
import 'package:flutter_ali_nike/data/source/Data_Source/banner_datasource.dart';

final bannerRepository = IBannerRepository(BannerRemote(httpClient));

abstract class RepositoryBanner {
  Future<List<BannerData>> getAll();
}

class IBannerRepository implements RepositoryBanner {
  final BannerDataSource dataSourceB;

  IBannerRepository(this.dataSourceB);

  @override
  Future<List<BannerData>> getAll() {
    return dataSourceB.getAll();
  }
}
