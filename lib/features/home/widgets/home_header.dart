import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../favorites/pages/favorites_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CineVault',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Your Offline Cinema',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        _HeaderButton(
          icon: Icons.bookmark_border_rounded,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesPage()),
            );
          },
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
    );
  }
}
