import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/data/comment.dart';

class CommentsItem extends StatelessWidget {
  final CommentEntity comment;
  const CommentsItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
          border: Border.all(color: themeData.dividerColor, width: 1),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.title.toString()),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      comment.email.toString(),
                      style: themeData.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                comment.date.toString(),
                style: themeData.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            comment.content.toString(),
            style: const TextStyle(height: 1.4),
          ),
        ],
      ),
    );
  }
}
