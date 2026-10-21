import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../providers/video_provider.dart';
import '../../../providers/last_played_provider.dart';
import '../../../core/constants/load_state.dart';

import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/empty_view.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/permission_view.dart';

import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/last_played_widget.dart';
import '../widgets/video_card.dart';
import '../../../data/models/video_item.dart';
import '../../player/pages/player_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoProvider>().loadVideos();
      context.read<LastPlayedProvider>().loadLastPlayed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<VideoProvider>(
          builder: (context, provider, child) {
            final lastPlayedProvider = context.watch<LastPlayedProvider>();

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: HomeHeader(),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: HomeSearchBar(),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: provider.refreshVideos,
                    child: _buildBody(provider),
                  ),
                ),

                if (lastPlayedProvider.hasLastPlayed)
                  LastPlayedWidget(
                    lastPlayed: lastPlayedProvider.lastPlayed!,
                    onTap: () async {
                      final lastPlayed = lastPlayedProvider.lastPlayed!;

                      final file = File(lastPlayed.videoPath);

                      if (!await file.exists()) {
                        return;
                      }

                      if (!context.mounted) return;

                      final video = VideoItem(
                        id: lastPlayed.videoId,
                        displayName: lastPlayed.videoName,
                        path: lastPlayed.videoPath,
                        duration: Duration(milliseconds: lastPlayed.duration),
                        size: await file.length(),
                        dateModified: lastPlayed.lastPlayed,
                      );

                      if (!context.mounted) return;

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayerPage(video: video),
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(VideoProvider provider) {
    switch (provider.state) {
      case LoadState.initial:
      case LoadState.loading:
        return const LoadingView();

      case LoadState.empty:
        return const EmptyView();

      case LoadState.permissionDenied:
        return PermissionView(
          onPressed: () {
            provider.loadVideos();
          },
        );

      case LoadState.error:
        return ErrorView(
          message: provider.message ?? 'Terjadi kesalahan.',
          onRetry: provider.loadVideos,
        );

      case LoadState.loaded:
        final videos = provider.filteredVideos;

        if (videos.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off_rounded, size: 56, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Video tidak ditemukan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Coba gunakan kata kunci lain.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 8),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];

            return VideoCard(
              video: video,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlayerPage(video: video)),
                );

                if (!mounted) return;

                await context.read<LastPlayedProvider>().refresh();
              },
            );
          },
        );
    }
  }
}
