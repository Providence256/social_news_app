import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/providers/post_notifier.dart';
import 'package:social_media_app/providers/theme_notifier.dart';
import 'package:social_media_app/widgets/error_state_widget.dart';
import 'package:social_media_app/widgets/loading_state_widget.dart';

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
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  spacing: 12,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.white, size: 24),
                    ),
                    Text(
                      'Providence Musaghi',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Spacer(),
                    Icon(Icons.more_vert),
                  ],
                ),
              ),

              // Post Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      post.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/post-details',
                        arguments: {'postId': post.id, 'postData': post},
                      ),
                      child: Text(
                        post.body.replaceAll('\n', ''),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  spacing: 16,
                  children: [
                    Text(
                      '${12 + (post.id * 3)} likes',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${2 + (post.id % 5)} comments',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(color: Colors.grey[300], height: 1),
              ),

              // Post Actions
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  spacing: 20,
                  children: [
                    _buildActionButton(
                      context,
                      Icons.thumb_up_outlined,
                      'Like',
                      Colors.blue[600]!,
                    ),
                    _buildActionButton(
                      context,
                      Icons.chat_bubble_outline,
                      'Comment',
                      Colors.grey[600]!,
                    ),
                    _buildActionButton(
                      context,
                      Icons.share_outlined,
                      'Share',
                      Colors.grey[600]!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          spacing: 6,
          children: [
            Icon(icon, color: color, size: 20),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
