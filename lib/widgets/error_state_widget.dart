import 'package:flutter/material.dart';
import 'package:social_media_app/api/api_response.dart';
import 'package:social_media_app/error/error_handling_message.dart';

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return ErrorHandlingMessage(
      error: ApiError(
        message: error.toString(),
        type: NetWorkErrorType.unknown,
      ),
      onRetry: onRetry,
    );
  }
}
