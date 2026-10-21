import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/favorite_provider.dart';
import '../../../data/models/video_item.dart';
import '../../player/pages/player_page.dart';
import '../../home/widgets/video_thumbnail_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FavoriteProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Favorit')),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.message != null) {
            return Center(child: Text(provider.message!));
          }

          final favorites = provider.favorites;

          if (favorites.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bookmark_border_rounded,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada video favorit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Video yang kamu tandai sebagai favorit akan muncul di sini.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];

              final videoId = favorite['video_id'] as String;
              final videoName = favorite['video_name'] as String;
              final videoPath = favorite['video_path'] as String;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: FutureBuilder<int>(
                    future: File(videoPath).exists().then(
                      (exists) => exists ? File(videoPath).length() : 0,
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == 0) {
                        return const SizedBox(
                          width: 110,
                          height: 68,
                          child: Icon(Icons.movie_outlined, size: 32),
                        );
                      }

                      final video = VideoItem(
                        id: videoId,
                        displayName: videoName,
                        path: videoPath,
                        duration: Duration.zero,
                        size: snapshot.data!,
                        dateModified: DateTime.now(),
                      );

                      return VideoThumbnailWidget(
                        video: video,
                        width: 110,
                        height: 68,
                        borderRadius: BorderRadius.circular(12),
                      );
                    },
                  ),
                  title: Text(
                    videoName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: const Text('Video favorit'),
                  onTap: () async {
                    final file = File(videoPath);

                    if (!await file.exists()) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('File video tidak ditemukan.'),
                        ),
                      );
                      return;
                    }

                    final video = VideoItem(
                      id: videoId,
                      displayName: videoName,
                      path: videoPath,
                      duration: Duration.zero,
                      size: await file.length(),
                      dateModified: DateTime.now(),
                    );

                    if (!context.mounted) return;

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlayerPage(video: video),
                      ),
                    );
                  },
                  trailing: IconButton(
                    tooltip: 'Hapus dari favorit',
                    icon: const Icon(Icons.bookmark_remove_rounded),
                    onPressed: () {
                      provider.removeFavorite(videoId);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
