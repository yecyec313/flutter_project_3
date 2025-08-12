import 'package:flutter_ali_nike/data/common/http.dart';

import 'package:flutter_ali_nike/data/source/Data_Source/comment_datasource.dart';
import 'package:flutter_ali_nike/data/source/Data/comments.dart';

final commentsRepository = ICommentRepository(CommentRemote(httpClient));

abstract class CommentsRepository {
  Future<List<CommentData>> getAll({required int id});
  Future<CommentData> insert(String title, String content, int productId);
}

class ICommentRepository implements CommentsRepository {
  final CommentDataSource dataSource;

  ICommentRepository(this.dataSource);
  @override
  Future<List<CommentData>> getAll({required int id}) {
    return dataSource.getAll(id: id);
  }

  @override
  Future<CommentData> insert(String title, String content, int productId) {
    return dataSource.insert(title, content, productId);
  }
}
