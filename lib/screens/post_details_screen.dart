import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/models/comment.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/providers/comment_notifier.dart';
import 'package:social_media_app/widgets/error_state_widget.dart';
import 'package:social_media_app/widgets/loading_state_widget.dart';

class PostDetailsScreen extends ConsumerWidget {
  const PostDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final postId = args['postId'];
    final post = args['postData'];

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPostContent(context, post),
            _buildCommentSection(context, postId, ref),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 1,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back),
      ),
      title: Text('Post', style: Theme.of(context).textTheme.headlineMedium),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.share)),
        IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border)),
      ],
    );
  }

  Widget _buildPostContent(BuildContext context, Post post) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.orange,
                  child: Text(
                    'A',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge!.copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Providence Musaghi',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '3 hours ago',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Follow',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  post.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(height: 1.3),
                ),
                Text(post.body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentSection(BuildContext context, int postId, WidgetRef ref) {
    final comments = ref.watch(commentsProvider(postId));
    return comments.when(
      data: (comments) {
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Comments (${comments.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _buildCommentItem(context, comment);
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => ErrorStateWidget(error: error),
      loading: () => LoadingStateWidget(),
    );
  }

  Widget _buildCommentItem(BuildContext context, Comment comment) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          CircleAvatar(
            radius: 20,
            child: Text(
              comment.email[0].toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.email,
                        style: Theme.of(context).textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Text(
                  comment.body,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(height: 1.4),
                ),
                SizedBox(height: 8),
                Row(
                  spacing: 16,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.thumb_up_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          Text(
                            'Like',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Reply',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
