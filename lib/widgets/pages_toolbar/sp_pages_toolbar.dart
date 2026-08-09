import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storypad/app_theme.dart';
import 'package:storypad/core/constants/app_constants.dart';
import 'package:storypad/core/databases/models/story_preferences_db_model.dart';
import 'package:storypad/core/extensions/font_weight_extension.dart';
import 'package:storypad/core/objects/story_page_object.dart';
import 'package:storypad/core/rich_text/rich_text.dart';
import 'package:storypad/providers/device_preferences_provider.dart';
import 'package:storypad/views/settings/local_widgets/font_weight_tile.dart';
import 'package:storypad/widgets/bottom_sheets/sp_font_weight_sheet.dart';
import 'package:storypad/widgets/bottom_sheets/sp_fonts_sheet.dart';
import 'package:storypad/widgets/sp_icons.dart';

part './title_toolbar.dart';

class SpPagesToolbar extends StatefulWidget {
  const SpPagesToolbar({
    super.key,
    required this.pages,
    required this.preferences,
    required this.onThemeChanged,
    required this.backgroundColor,
    required this.managingPage,
  });

  final bool managingPage;
  final List<StoryPageObject> pages;
  final StoryPreferencesDbModel preferences;
  final void Function(StoryPreferencesDbModel) onThemeChanged;
  final Color? backgroundColor;

  @override
  State<SpPagesToolbar> createState() => SpPagesToolbarState();
}

class SpPagesToolbarState extends State<SpPagesToolbar> {
  Map<int, void Function()> titleFocusListenters = {};
  Map<int, void Function()> bodyFocusListenters = {};

  bool titleFocused = false;
  int? bodyFocusedIndex;

  @override
  void initState() {
    super.initState();
    setupListeners();
  }

  void setupListeners() {
    for (int index = 0; index < widget.pages.length; index++) {
      titleFocusListenters[index] = () => titleFocusListener(index);
      bodyFocusListenters[index] = () => bodyFocusListener(index);

      widget.pages[index].titleFocusNode.addListener(titleFocusListenters[index]!);
      widget.pages[index].bodyFocusNode.addListener(bodyFocusListenters[index]!);
    }
  }

  @override
  void didUpdateWidget(covariant SpPagesToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    clearPreviousListeners();
    setupListeners();
  }

  void clearPreviousListeners() {
    for (int index = 0; index < widget.pages.length; index++) {
      if (titleFocusListenters[index] != null) {
        widget.pages[index].titleFocusNode.removeListener(titleFocusListenters[index]!);
      }
      if (bodyFocusListenters[index] != null) {
        widget.pages[index].bodyFocusNode.removeListener(bodyFocusListenters[index]!);
      }
    }

    titleFocusListenters.clear();
    bodyFocusListenters.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    clearPreviousListeners();
    setupListeners();
  }

  void titleFocusListener(int index) {
    if (index >= widget.pages.length) return;
    if (widget.pages[index].titleFocusNode.hasFocus) {
      titleFocused = true;
    } else {
      bool everyBodyNoFocus = widget.pages.every((e) => !e.bodyFocusNode.hasFocus);
      if (everyBodyNoFocus && titleFocused) {
        titleFocused = true;
      } else {
        titleFocused = false;
      }
    }

    if (mounted) setState(() {});
  }

  void bodyFocusListener(int index) {
    if (index >= widget.pages.length) return;
    if (widget.pages[index].bodyFocusNode.hasFocus) {
      bodyFocusedIndex = index;
      titleFocused = false;
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    clearPreviousListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isVisible = !widget.managingPage && (titleFocused || bodyFocusedIndex != null);

    return Visibility(
      visible: isVisible,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: widget.backgroundColor?.withValues(alpha: 0.75) ?? Theme.of(context).colorScheme.surface.withValues(alpha: 0.75),
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    if (titleFocused) buildTitleToolbar(context),
                    if (!titleFocused)
                      ...List.generate(
                        widget.pages.length,
                        (index) {
                          return Visibility(
                            visible: index == bodyFocusedIndex,
                            child: editorAdapter.buildToolbar(
                              context: context,
                              controller: widget.pages[index].bodyController,
                              backgroundColor: Colors.transparent,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitleToolbar(BuildContext context) {
    return _TitleToolbar(
      preferences: widget.preferences,
      onThemeChanged: (preferences) => widget.onThemeChanged(preferences),
    );
  }
}
