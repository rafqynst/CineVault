import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/video_provider.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        context.read<VideoProvider>().searchVideos(value);
      },
      decoration: InputDecoration(
        hintText: 'Cari video...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}