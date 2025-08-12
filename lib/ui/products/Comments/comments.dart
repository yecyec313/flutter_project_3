import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ali_nike/data/repo/repository_comment.dart';
import 'package:flutter_ali_nike/ui/products/Comments/bloc/comments_bloc.dart';
import 'package:flutter_ali_nike/ui/products/Comments/commentsItem.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsList extends StatelessWidget {
  final int id;
  const CommentsList({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocProvider(
        create: (context) {
          final CommentsBloc commentBloc = CommentsBloc(commentsRepository, id);
          commentBloc.add(CommentStarted());
          return commentBloc;
        },
        child:
            BlocBuilder<CommentsBloc, CommentsState>(builder: (context, state) {
          if (state is CommentsSuccess) {
            debugPrint(state.comments.length.toString());
            return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return
                  //  Container(
                  //   height: 100,
                  //   padding: EdgeInsets.all(12),
                  //   child: Center(
                  //     child: Text('asasasas'),
                  //   ),
                  // );
                  CommentsItem(
                comment: state.comments[index],
              );
            }, childCount: state.comments.length));
          } else if (state is CommentsLoading) {
            return SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is CommentsError) {
            return SliverToBoxAdapter(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(state.exception.message),
                    ElevatedButton(
                        onPressed: () {
                          // context.read<HomeBlocBloc>().add(HomeRefresh());
                          BlocProvider.of<CommentsBloc>(context)
                              .add(CommentStarted());
                        },
                        child: const Text('تلاش دوباره')),
                  ],
                ),
              ),
            );
          } else {
            throw Exception('state is not supported');
          }
        }),
      ),
    );
  }
}
