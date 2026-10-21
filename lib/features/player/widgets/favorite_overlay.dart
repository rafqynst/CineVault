
import 'dart:ui';

import 'package:flutter/material.dart';


class FavoriteOverlay extends StatelessWidget {
  final bool isOpen;
  final bool controlsVisible;
  final VoidCallback onToggle;
  final Widget child;

  const FavoriteOverlay({
    super.key,
    required this.isOpen,
    required this.controlsVisible,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          if (isOpen)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 56),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.48,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(20),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 14,
                          sigmaY: 14,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF211A30)
                                .withValues(alpha: 0.78),
                            border: Border(
                              right: BorderSide(
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                          ),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          if (controlsVisible)
            Positioned(
              left: 16,
              top: 12,
              child: SafeArea(
                bottom: false,
                child: Material(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: onToggle,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                      ),
                      child: Icon(
                        isOpen
                            ? Icons.close_rounded
                            : Icons.bookmarks_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
