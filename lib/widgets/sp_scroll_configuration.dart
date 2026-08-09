import 'dart:io';
import 'package:flutter/material.dart';

class SpScrollConfiguration extends StatelessWidget {
  const SpScrollConfiguration({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        scrollbars: false,
      ),
      child: child,
    );
  }
}
