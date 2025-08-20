import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_media_app/providers/theme_notifier.dart';
import 'package:social_media_app/screens/feed_screen.dart';
import 'package:social_media_app/screens/post_details_screen.dart';
import 'package:social_media_app/services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferencesService.init();
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) => FeedScreen(),
        '/post-details': (context) => PostDetailsScreen(),
      },
    );
  }
}
