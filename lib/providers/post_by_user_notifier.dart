import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/api/api_response.dart';
import 'package:social_media_app/api/json_placeholder_service.dart';
import 'package:social_media_app/models/post.dart';

class PostByUserAsyncNotifier extends FamilyAsyncNotifier<List<Post>, int> {
  @override
  Future<List<Post>> build(int userId) async {
    final response = await JsonPlaceholderService.getPostByUser(userId);

    return switch (response) {
      ApiSuccess<List<Post>>(data: final posts) => () {
        return posts;
      }(),

      ApiError<List<Post>>(message: final message, type: final type) => () {
        throw switch (type) {
          NetWorkErrorType.notFound => Exception('Post $userId not found'),
          NetWorkErrorType.noConnection => Exception('No internet connection'),
          _ => Exception('Failed to load posts: $message'),
        };
      }(),
    };
  }
}

final postByUserProvider =
    AsyncNotifierProvider.family<PostByUserAsyncNotifier, List<Post>, int>(() {
      return PostByUserAsyncNotifier();
    });
