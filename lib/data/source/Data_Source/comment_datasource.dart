import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ali_nike/data/common/mixin.dart';
import 'package:flutter_ali_nike/data/source/Data/comments.dart';

abstract class CommentDataSource {
  Future<List<CommentData>> getAll({required int id});
  Future<CommentData> insert(String title, String content, int productId);
}

class CommentRemote with HttpResponseValidator implements CommentDataSource {
  final Dio httpClient;

  CommentRemote(this.httpClient);
  @override
  Future<List<CommentData>> getAll({required int id}) async {
    final response = await httpClient.get('comment/list?product_id=$id');
    validateResponse(response);
    final List<CommentData> comments = [];
    for (var element in (response.data as List<dynamic>)) {
      comments.add(CommentData.fromJson(element));
      debugPrint(response.data.toString());
    }
    return comments;
  }

  @override
  Future<CommentData> insert(
      String title, String content, int productId) async {
    final response = await httpClient.post("comment/add",
        data: {"title": title, "content": content, "product_id": productId});
    validateResponse(response);
    return CommentData.fromJson(response.data);
  }
}
