import 'package:flutter/material.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/widgets/action_button_widget.dart';

class PostGridContainer extends StatelessWidget {
  const PostGridContainer({
    super.key,
    required this.theme,
    required this.user,
    required this.post,
  });

  final ThemeData theme;
  final User user;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
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
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/user-profile',
                    arguments: {'userId': user.id, 'userData': user},
                  ),
                  child: Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
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
                Text(post.title, style: Theme.of(context).textTheme.titleLarge),
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
                ActionButtonWidget(
                  icon: Icons.thumb_up_outlined,
                  label: 'Like',
                  color: Colors.blue[600]!,
                ),
                ActionButtonWidget(
                  icon: Icons.chat_bubble_outline,
                  label: 'Comment',
                  color: Colors.grey[600]!,
                ),
                ActionButtonWidget(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  color: Colors.grey[600]!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
