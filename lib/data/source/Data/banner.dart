class BannerData {
  final int id;
  final String imageUrl;
  BannerData(this.id, this.imageUrl);
  BannerData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        imageUrl = json['image'];
}

class BannerData1 {
  final int id;
  final String imageUrl;

  BannerData1({required this.id, required this.imageUrl});
}

class AppDataBase {
  static List<BannerData1> get posts {
    return [
      BannerData1(id: 0, imageUrl: 'kafsh3.jpg'),
      BannerData1(id: 1, imageUrl: 'KAFSH2.jpg'),
      BannerData1(id: 2, imageUrl: 'KAFSH1.jpg')
    ];
  }
}
