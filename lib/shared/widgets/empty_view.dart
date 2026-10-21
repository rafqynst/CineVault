import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String title;
  final String subtitle;

  const EmptyView({
    super.key,
    this.title = 'Tidak ada video',
    this.subtitle =
        'Video dengan durasi minimal 5 menit tidak ditemukan.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.video_library_outlined,
              size: 72,
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}