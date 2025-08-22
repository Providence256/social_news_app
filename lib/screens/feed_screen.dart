import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/providers/post_notifier.dart';
import 'package:social_media_app/providers/theme_notifier.dart';
import 'package:social_media_app/providers/user_notifier.dart';
import 'package:social_media_app/widgets/error_state_widget.dart';
import 'package:social_media_app/widgets/loading_state_widget.dart';
import 'package:social_media_app/widgets/post_grid_container.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsyncValue = ref.watch(postsProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Header Section
              _buildHeader(context, ref),
              // status Section

              // Main post
              postsAsyncValue.when(
                data: (posts) => _buildMainPost(posts, ref),
                error: (error, stackTrace) => ErrorStateWidget(
                  error: error,
                  onRetry: () async {
                    try {
                      await ref.read(postsProvider.notifier).refresh();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to retry: $e')),
                        );
                      }
                    }
                  },
                ),
                loading: () => LoadingStateWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Social News', style: Theme.of(context).textTheme.headlineLarge),
          Row(
            spacing: 8,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.search, color: Colors.blue[700]),
              ),

              GestureDetector(
                onTap: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    theme.brightness == Brightness.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainPost(List<Post> posts, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final user = ref.watch(userProvider(post.userId));
        return user.when(
          data: (user) =>
              PostGridContainer(theme: theme, user: user, post: post),
          error: (error, stackTrace) => ErrorStateWidget(error: error),
          loading: () => LoadingStateWidget(),
        );
      },
    );
  }
}
