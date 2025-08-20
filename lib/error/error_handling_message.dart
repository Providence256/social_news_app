import 'package:flutter/material.dart';
import 'package:social_media_app/api/api_response.dart';

class ErrorHandlingMessage extends StatelessWidget {
  const ErrorHandlingMessage({super.key, required this.error, this.onRetry});

  final ApiError error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final (icon, color, title, suggestions) = switch (error.type) {
      NetWorkErrorType.noConnection => (
        Icons.wifi_off,
        Colors.blue,
        'No Internet',
        [
          'Check your WIfi or mobile data',
          'Move to an area with better signal',
          'Try again in a moment',
        ],
      ),
      NetWorkErrorType.timeout => (
        Icons.access_time,
        Colors.orange,
        'Request Timed Out',
        [
          'Check your internet speed',
          'Try again with a better connection',
          'The server might be slow',
        ],
      ),

      NetWorkErrorType.notFound => (
        Icons.search_off,
        Colors.grey,
        'Content Not Found',
        [
          'The requested content may have been removed',
          'Check if you have the correct informaton',
          'Try refreshing the page',
        ],
      ),

      NetWorkErrorType.unauthorized => (
        Icons.lock,
        Colors.red,
        'Access Denied',
        [
          'You may need to log in',
          'Check your permissions',
          'Contact support if this persists',
        ],
      ),

      NetWorkErrorType.serverError => (
        Icons.error_outline,
        Colors.purple,
        'Server Error',
        [
          'The server is experiencing issues',
          'Try again in few minutes',
          'Contact support if this continues',
        ],
      ),

      NetWorkErrorType.parseError => (
        Icons.code_off,
        Colors.amber,
        'Data Format Error',
        [
          'The server returned invalid data',
          'Try refreshing to get fresh data',
          'Report this issue if it persists',
        ],
      ),

      _ => (
        Icons.warning,
        Colors.grey,
        'Something went wrong',
        [
          'An unexpected error occurred',
          'try again later',
          'Contact support if needed',
        ],
      ),
    };
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(icon, size: 64, color: color),
          SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),

          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.orange),
                      Text(
                        'try these solutions',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ...suggestions.map(
                    (suggestion) => Padding(
                      padding: EdgeInsetsGeometry.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('*', style: TextStyle(color: color)),
                          Expanded(child: Text(suggestion)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),
          if (onRetry != null)
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh),
              label: Text('Try again'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
        ],
      ),
    );
  }
}
