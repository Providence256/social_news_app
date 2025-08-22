import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/api/api_response.dart';
import 'package:social_media_app/api/json_placeholder_service.dart';
import 'package:social_media_app/models/user.dart';

class UserAsyncNotifier extends FamilyAsyncNotifier<User, int> {
  @override
  Future<User> build(int userId) async {
    final response = await JsonPlaceholderService.getUser(userId);

    return switch (response) {
      ApiSuccess<User>(data: final user) => () {
        return user;
      }(),
      ApiError<User>(message: final message, type: final type) => () {
        throw switch (type) {
          NetWorkErrorType.notFound => Exception('User $userId not found'),
          NetWorkErrorType.noConnection => Exception('No internet connection'),

          _ => Exception('Failed to load user: $message'),
        };
      }(),
    };
  }
}

final userProvider = AsyncNotifierProvider.family<UserAsyncNotifier, User, int>(
  () {
    return UserAsyncNotifier();
  },
);
