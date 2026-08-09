import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:storypad/providers/device_preferences_provider.dart';
import 'package:storypad/providers/root_provider.dart';
import 'package:storypad/widgets/side_items/side_items.dart';

class RootBottomNavBar extends StatelessWidget {
  const RootBottomNavBar({super.key, required this.rootProvider});

  final RootProvider rootProvider;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: rootProvider.selectedRootRouteNameNotifier,
      builder: (context, selectedRouteName, child) {
        final devicePreferencesProvider = context.watch<DevicePreferencesProvider>();
        final sideItems = SideItems.getSideMenuItems(
          enableRelaxSounds: devicePreferencesProvider.enableRelaxSounds,
        );

        int currentIndex = sideItems.indexWhere((item) => item.route.routeName == selectedRouteName);
        if (currentIndex == -1) currentIndex = 0; 

        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
              child: SafeArea(
                top: false,
                child: CupertinoTabBar(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.5,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  currentIndex: currentIndex,
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  onTap: (index) {
                    HapticFeedback.selectionClick();
                    final item = sideItems[index];
                    if (item.onTap != null) {
                      item.onTap!(context, item.route);
                    }
                  },
                  items: sideItems.map((item) {
                    return BottomNavigationBarItem(
                      icon: Icon(item.iconData, size: 24),
                      activeIcon: Icon(item.selectedIconData, size: 24),
                      label: item.title,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
