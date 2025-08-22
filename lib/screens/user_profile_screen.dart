import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/providers/post_by_user_notifier.dart';
import 'package:social_media_app/providers/theme_notifier.dart';
import 'package:social_media_app/widgets/error_state_widget.dart';
import 'package:social_media_app/widgets/loading_state_widget.dart';
import 'package:social_media_app/widgets/post_grid_container.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final user = args['userData'];
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder: (context, inneBoxIsScrolled) {
          return [_buildSliverAppBar(context, user)];
        },
        body: _buildTabBarView(ref, user),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context, User user) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_vert, color: Colors.black),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildProfileHeader(context, user),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.black,
            indicatorWeight: 1,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Icon(Icons.grid_on, color: Colors.black, size: 20),
                    Text(
                      'Posts',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Icon(Icons.bookmark_border, color: Colors.black, size: 20),
                    Text(
                      'Saved',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, User user) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 100, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.orange,
                    child: Text(
                      'A',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineLarge!.copyWith(fontSize: 66),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn('Posts', '25'),
                    _buildStatColumn('Followers', '258'),
                    _buildStatColumn('Following', '156'),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.verified, color: Colors.blue, size: 16),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(user.email),
              ],
            ),
          ),

          // Action Button
          SizedBox(height: 20),
          Row(
            spacing: 8,
            children: [
              Expanded(flex: 3, child: _buildFollowButton()),
              Expanded(child: _buildMessageButton(context)),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(Icons.person_add_outlined, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      spacing: 2,
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _buildFollowButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text('Follow', style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
    );
  }

  Widget _buildMessageButton(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          'Message',
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.copyWith(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildTabBarView(WidgetRef ref, User user) {
    return TabBarView(
      controller: _tabController,
      children: [_buildPostsGrid(ref, user), _buildPostsGrid(ref, user)],
    );
  }

  Widget _buildPostsGrid(WidgetRef ref, User user) {
    final posts = ref.watch(postByUserProvider(user.id));
    final theme = ref.watch(themeProvider);
    return posts.when(
      data: (posts) {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            padding: EdgeInsets.all(1),
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostGridContainer(theme: theme, user: user, post: post);
            },
          ),
        );
      },
      error: (error, stackTrace) => ErrorStateWidget(error: error),
      loading: () => LoadingStateWidget(),
    );
  }
}
