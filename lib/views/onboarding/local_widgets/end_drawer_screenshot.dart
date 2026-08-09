import 'package:flutter/material.dart';

enum EndDrawerScreenshotState {
  noSignedIn,
  signedIn,
  syning,
  synced,
}

class EndDrawerScreenshot extends StatelessWidget {
  const EndDrawerScreenshot({
    super.key,
    required this.state,
  });

  final EndDrawerScreenshotState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    final isSignedIn = state != EndDrawerScreenshotState.noSignedIn;
    final isSyncing = state == EndDrawerScreenshotState.syning;
    final isSynced = state == EndDrawerScreenshotState.synced;

    return Container(
      width: 221,
      height: 360,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252538) : const Color(0xFFFFFFFF),
        borderRadius: const BorderRadius.only(topRight: Radius.circular(24.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Profile / Sync Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    isSignedIn ? Icons.person_rounded : Icons.person_outline_rounded,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSignedIn ? 'My Account' : 'Sign In',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        isSignedIn ? 'Cloud Backup On' : 'Tap to sign in',
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Google Drive Backup Tile
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.add_to_drive_rounded, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Google Drive Sync',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (isSyncing)
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else if (isSynced)
                    Icon(Icons.check_circle_rounded, size: 16, color: Colors.green.shade600)
                  else
                    Icon(Icons.sync_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 100% Private Cloud Status
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.security_rounded, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '100% Private & Safe',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Stored in your Drive',
                          style: TextStyle(
                            fontSize: 9,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
