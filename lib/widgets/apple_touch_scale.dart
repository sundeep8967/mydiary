import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppleTouchScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AppleTouchScale({super.key, required this.child, this.onTap});

  @override
  State<AppleTouchScale> createState() => _AppleTouchScaleState();
}

class _AppleTouchScaleState extends State<AppleTouchScale> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isDown = true),
      onTapUp: (_) {
        setState(() => _isDown = false);
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapCancel: () => setState(() => _isDown = false),
      child: widget.child.animate(target: _isDown ? 1 : 0).scaleXY(
            end: 0.95,
            duration: 150.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}
