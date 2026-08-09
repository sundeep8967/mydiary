import 'dart:async';
import 'package:flutter/material.dart';
import 'package:storypad/core/constants/app_constants.dart';
import 'package:storypad/core/services/app_logo_service.dart';

class SpSplashScreenWrapper extends StatefulWidget {
  const SpSplashScreenWrapper({
    super.key,
    required this.onLoad,
    required this.app,
  });

  final Future<void> Function() onLoad;
  final Widget app;

  static void markAsLoaded(BuildContext context) {
    context.findAncestorStateOfType<_SpSplashScreenWrapperState>()?.markAsLoaded();
  }

  static Future<void> ensureInitialized() async {
    kAppLogo = await AppLogoService().getCurrent();
  }

  @override
  State<SpSplashScreenWrapper> createState() => _SpSplashScreenWrapperState();
}

class _SpSplashScreenWrapperState extends State<SpSplashScreenWrapper> with SingleTickerProviderStateMixin {
  bool initialized = false;
  bool loaded = false;

  late final AnimationController animationController;

  // Ensure initialization is fully complete before mark as loaded and reverse splash and hide it.
  final Completer initializeCompleter = Completer();

  bool get isDarkMode => WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 350),
    );

    load();
  }

  Future<void> load() async {
    await Future.wait([
      animationController.forward(),
      widget.onLoad(),
    ]);

    initializeCompleter.complete(true);
    setState(() => initialized = true);
  }

  void markAsLoaded() async {
    if (loaded) return;

    await initializeCompleter.future;
    await animationController.reverse();

    setState(() => loaded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          if (initialized) RepaintBoundary(child: widget.app),
          if (!loaded) buildSplash(),
        ],
      ),
    );
  }

  Widget buildSplash() {
    Color backgroundColor = Colors.white;

    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.ease,
    );

    return Container(
      color: initialized ? null : backgroundColor,
      child: FadeTransition(
        opacity: animation,
        child: Container(
          decoration: BoxDecoration(color: backgroundColor),
          alignment: .center,
          child: Image(
            image: kAppLogo!.asset.provider(),
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
