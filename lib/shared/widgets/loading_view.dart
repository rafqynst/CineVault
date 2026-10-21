import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({
    super.key,
    this.message = 'Memindai video...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 18),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}