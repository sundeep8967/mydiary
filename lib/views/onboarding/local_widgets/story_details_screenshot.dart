import 'package:flutter/material.dart';

class StoryDetailsScreenshot extends StatelessWidget {
  const StoryDetailsScreenshot({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      width: 300,
      height: 360,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : const Color(0xFFFFFFFF),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Editor Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back_rounded, size: 20, color: colorScheme.onSurface),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 10, color: colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Aug 9, 2026',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.more_vert_rounded, size: 18, color: colorScheme.onSurfaceVariant),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A letter to my future self',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Hey future me! I hope you're doing well. Right now, I'm chasing dreams, building beautiful apps, and learning every single day...",
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Styled Photo / Media attachment pill mockup
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library_rounded, color: colorScheme.primary, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Memories & Photos attached',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Rich Text Toolbar Mockup at bottom
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.format_bold_rounded, size: 16, color: colorScheme.primary),
                Icon(Icons.format_italic_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                Icon(Icons.format_list_bulleted_rounded, size: 16, color: colorScheme.onSurfaceVariant),
                Icon(Icons.image_outlined, size: 16, color: colorScheme.onSurfaceVariant),
                Icon(Icons.location_on_outlined, size: 16, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
