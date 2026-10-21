import 'package:flutter/material.dart';

class PermissionView extends StatelessWidget {
  final VoidCallback onPressed;

  const PermissionView({
    super.key,
    required this.onPressed,
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
              Icons.lock_outline_rounded,
              size: 72,
            ),
            const SizedBox(height: 20),
            Text(
              'Izin diperlukan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Text(
              'CineVault membutuhkan izin untuk membaca video dari penyimpanan perangkat.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.security),
              label: const Text('Berikan Izin'),
            ),
          ],
        ),
      ),
    );
  }
}