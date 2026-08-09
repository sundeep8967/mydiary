part of '../relax_sounds_view.dart';

class _VolumeSlider extends StatelessWidget {
  const _VolumeSlider({
    required this.relaxSound,
  });

  final RelaxSoundObject relaxSound;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RelaxSoundsProvider>(context);
    return Positioned(
      top: 2.0,
      left: 16.0,
      right: 16.0,
      child: CupertinoSlider(
        divisions: 10,
        activeColor: Theme.of(context).colorScheme.primary,
        thumbColor: Theme.of(context).colorScheme.surface,
        value: provider.getVolume(relaxSound)!,
        onChanged: (value) => provider.setVolume(relaxSound, value),
      ),
    );
  }
}
