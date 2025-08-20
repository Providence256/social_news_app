import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/api/api_response.dart';
import 'package:social_media_app/api/json_placeholder_service.dart';
import 'package:social_media_app/models/comment.dart';

class CommentAsyncNotifier extends FamilyAsyncNotifier<List<Comment>, int> {
  @override
  Future<List<Comment>> build(int postId) async {
    final response = await JsonPlaceholderService.getCommentByPost(postId);

    return switch (response) {
      ApiSuccess<List<Comment>>(data: final comment) => () {
        return comment;
      }(),

      ApiError<List<Comment>>(message: final message, type: final type) => () {
        throw switch (type) {
          NetWorkErrorType.notFound => Exception('Comments $postId not found'),
          NetWorkErrorType.noConnection => Exception('No internet connection'),
          _ => Exception('Failed to load comments: $message'),
        };
      }(),
    };
  }
}

final commentsProvider =
    AsyncNotifierProvider.family<CommentAsyncNotifier, List<Comment>, int>(() {
      return CommentAsyncNotifier();
    });
