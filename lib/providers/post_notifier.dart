import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/api/api_response.dart';
import 'package:social_media_app/api/json_placeholder_service.dart';
import 'package:social_media_app/models/post.dart';

class PostAsyncNotifier extends AsyncNotifier<List<Post>> {
  List<Post>? _cachedPosts;
  DateTime? _lastFetch;

  @override
  FutureOr<List<Post>> build() {
    if (_cachedPosts != null && _lastFetch != null) {
      final cachedAge = DateTime.now().difference(_lastFetch!);

      if (cachedAge.inMinutes < 5) {
        return _cachedPosts!;
      }
    }

    return _fetchPosts();
  }

  Future<List<Post>> _fetchPosts() async {
    final response = await JsonPlaceholderService.getPosts();

    return switch (response) {
      ApiSuccess<List<Post>>(data: final posts) => () {
        _cachedPosts = posts;
        _lastFetch = DateTime.now();

        return posts;
      }(),
      ApiError<List<Post>>(message: final message, type: final type) => () {
        if (_cachedPosts != null) {
          return _cachedPosts!;
        }

        throw switch (type) {
          NetWorkErrorType.noConnection => Exception(
            'No internet connection. Please check your network and try again',
          ),
          NetWorkErrorType.timeout => Exception(
            'Request timed out. Please try again',
          ),
          NetWorkErrorType.serverError => Exception(
            'Server error. Please try again later',
          ),
          _ => Exception(message),
        };
      }(),
    };
  }

  Future<void> refresh() async {
    //state = AsyncValue.guard(() => _fetchPosts());
  }
}

final postsProvider = AsyncNotifierProvider<PostAsyncNotifier, List<Post>>(() {
  return PostAsyncNotifier();
});
