part of '../relax_sounds_view.dart';

class _SoundIconCard extends StatelessWidget {
  const _SoundIconCard({
    required this.relaxSound,
    required this.selected,
  });

  final RelaxSoundObject relaxSound;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: AnimatedContainer(
          curve: Curves.ease,
          duration: Durations.short2,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: selected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                : Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
            border: Border.all(
              color: selected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
                  : Theme.of(context).dividerColor.withValues(alpha: 0.2),
            ),
          ),
          child: SpFirestoreStorageDownloaderBuilder(
            filePath: relaxSound.svgIconUrlPath,
            builder: (context, file, failed) {
              if (file == null) return const _SoundIconLoading();
              return buildSvgIcon(file, context);
            },
          ),
        ),
      ),
    );
  }

  Widget buildSvgIcon(
    File file,
    BuildContext context,
  ) {
    Widget child = SvgPicture.file(
      file,
      semanticsLabel: relaxSound.label,
      height: 48,
      colorFilter: ColorFilter.mode(
        selected ? ColorScheme.of(context).primary : ColorScheme.of(context).onSurface,
        BlendMode.srcIn,
      ),
    );

    if (selected) {
      return SpLoopAnimationBuilder(
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
        child: child,
        builder: (context, value, child) {
          // Subtle pulse from 1.0 to 0.95 and back.
          // Since it's a loop animation, value goes 0.0 to 1.0 to 0.0...
          // We map 0.0-1.0 to a scale of 0.95 to 1.0.
          return Transform.scale(
            scale: lerpDouble(1.0, 0.92, value),
            child: child!,
          );
        },
      );
    }

    return child;
  }
}
