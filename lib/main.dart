import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'providers/video_provider.dart';

import 'data/datasource/media_store_datasource.dart';
import 'data/repositories/video_repository.dart';

import 'features/home/pages/home_page.dart';
import 'providers/last_played_provider.dart';

import 'providers/favorite_provider.dart';
import 'data/repositories/favorite_repository.dart';
import 'data/database/app_database.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),

        ChangeNotifierProvider(
          create: (_) =>
              VideoProvider(VideoRepository(const MediaStoreDataSource())),
        ),
        ChangeNotifierProvider(create: (_) => LastPlayedProvider()),

        ChangeNotifierProvider(
          create: (_) =>
              FavoriteProvider(FavoriteRepository(AppDatabase.instance)),
        ),
      ],
      child: const CineVaultApp(),
    ),
  );
}

class CineVaultApp extends StatelessWidget {
  const CineVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineVault',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
