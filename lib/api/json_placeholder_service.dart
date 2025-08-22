import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:social_media_app/api/api_response.dart';
import 'package:social_media_app/models/comment.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/user.dart';

class JsonPlaceholderService {
  static const String _baseurl = 'https://jsonplaceholder.typicode.com';
  static const Duration _timeout = Duration(seconds: 15);

  static final http.Client _client = http.Client();

  static ApiError<T> _handleError<T>(dynamic error, {http.Response? response}) {
    return switch (error) {
      SocketException() => ApiError<T>(
        message: 'No internet Connection',
        originalError: error,
        type: NetWorkErrorType.noConnection,
      ),

      TimeoutException() => ApiError<T>(
        message: 'Request timeout',
        type: NetWorkErrorType.timeout,
        originalError: error,
      ),

      FormatException() => ApiError<T>(
        message: 'Invalid data format',
        type: NetWorkErrorType.parseError,
        originalError: error,
      ),

      _ when response != null => switch (response.statusCode) {
        400 => ApiError<T>(
          message: 'Bad request',
          type: NetWorkErrorType.badRequest,
          statusCode: response.statusCode,
        ),
        401 => ApiError<T>(
          message: 'Unauthorized',
          type: NetWorkErrorType.unauthorized,
          statusCode: response.statusCode,
        ),
        404 => ApiError(
          message: 'Not Found',
          type: NetWorkErrorType.notFound,
          statusCode: response.statusCode,
        ),
        500 => ApiError<T>(
          message: 'Server error',
          type: NetWorkErrorType.serverError,
          statusCode: response.statusCode,
        ),

        _ => ApiError<T>(
          message: 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          type: NetWorkErrorType.unknown,
          statusCode: response.statusCode,
        ),
      },

      _ => ApiError<T>(
        message: 'Unknown error',
        type: NetWorkErrorType.unknown,
        originalError: error,
      ),
    };
  }

  // GET
  static Future<ApiResponse<T>> _get<T>(
    String endPoint,
    T Function(dynamic json) parser,
  ) async {
    final url = '$_baseurl$endPoint';

    try {
      final response = await _client
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json',
              'User-Agent': 'Flutter-JSONPlaceholder-Explorer/1.0',
            },
          )
          .timeout(_timeout);

      return switch (response.statusCode) {
        >= 200 && < 300 => () {
          try {
            final jsonData = json.decode(response.body);
            final parsedData = parser(jsonData);

            return ApiSuccess<T>(
              data: parsedData,
              headers: response.headers,
              statusCode: response.statusCode,
            );
          } catch (parseError) {
            return _handleError<T>(parseError, response: response);
          }
        }(),
        _ => _handleError<T>('HTTP ${response.statusCode}', response: response),
      };
    } catch (error) {
      return _handleError<T>(error);
    }
  }

  // POST

  static Future<ApiResponse<T>> _post<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(dynamic json) parser,
  ) async {
    final url = '$_baseurl$endpoint';

    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json',
            },
            body: json.encode(body),
          )
          .timeout(_timeout);

      return switch (response.statusCode) {
        200 || 200 => () {
          try {
            final jsonData = json.decode(response.body);
            final parsedData = parser(jsonData);

            return ApiSuccess<T>(
              data: parsedData,
              headers: response.headers,
              statusCode: response.statusCode,
            );
          } catch (parseError) {
            return _handleError<T>(parseError, response: response);
          }
        }(),

        _ => _handleError<T>('HTTP ${response.statusCode}', response: response),
      };
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  static Future<ApiResponse<List<Post>>> getPosts() async {
    return _get<List<Post>>(
      '/posts',
      (jsonData) => switch (jsonData) {
        List<dynamic> list =>
          list
              .map(
                (item) => switch (item) {
                  Map<String, dynamic> postJson => Post.fromMap(postJson),
                  _ => throw FormatException('Invalid post format: $item'),
                },
              )
              .toList(),
        _ => throw FormatException(
          'Expected list of posts, got: ${jsonData.runtimeType}',
        ),
      },
    );
  }

  static Future<ApiResponse<Post>> createPost({
    required String title,
    required String body,
    required int userId,
  }) {
    return _post(
      '/posts',
      {'title': title, 'body': body, 'userId': userId},
      (jsonData) => switch (jsonData) {
        Map<String, dynamic> postJson => Post.fromMap(postJson),
        _ => throw FormatException(
          'Expected post object, got:${jsonData.runtimeType}',
        ),
      },
    );
  }

  static Future<ApiResponse<List<Post>>> getPostByUser(int userId) async {
    return _get(
      '/posts?userId=$userId',
      (jsonData) => switch (jsonData) {
        List<dynamic> list when list.isNotEmpty =>
          list
              .where(
                (item) => switch (item) {
                  Map<String, dynamic> post => post['userId'] == userId,
                  _ => false,
                },
              )
              .map((item) => Post.fromMap(item as Map<String, dynamic>))
              .toList(),
        List<dynamic> _ => <Post>[],
        _ => throw FormatException(
          'Expected list of posts, got:${jsonData.runtimeType}',
        ),
      },
    );
  }

  static Future<ApiResponse<User>> getUser(int userId) async {
    return _get('/users/$userId', (jsonData) {
      return switch (jsonData) {
        Map<String, dynamic> userJson => User.fromMap(userJson),
        _ => throw FormatException(
          'Expected user object, got: ${jsonData.runtimeType}',
        ),
      };
    });
  }

  static Future<ApiResponse<List<Comment>>> getCommentByPost(int postId) async {
    return _get(
      '/comments?postId=$postId',
      (jsonData) => switch (jsonData) {
        List<dynamic> list when list.isNotEmpty =>
          list
              .where(
                (item) => switch (item) {
                  Map<String, dynamic> comment => comment['postId'] == postId,
                  _ => false,
                },
              )
              .map((item) => Comment.fromMap(item as Map<String, dynamic>))
              .toList(),
        List<dynamic> _ => <Comment>[],
        _ => throw FormatException(
          'Expected list of comments, got:${jsonData.runtimeType}',
        ),
      },
    );
  }

  // cleanup method
  static void dispose() {
    _client.close();
  }
}
