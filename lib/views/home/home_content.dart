part of 'home_view.dart';

class _HomeContent extends StatelessWidget {
  const _HomeContent(this.viewModel);

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SpStoryListMultiEditWrapper(
      builder: (BuildContext context) {
        return buildScaffold(context);
      },
    );
  }

  Widget buildScaffold(BuildContext context) {
    return DefaultTabController(
      length: viewModel.months.length,
      child: _HomeScaffold(
        viewModel: viewModel,
        endDrawer: null,
        appBarSlivers: _buildHomeAppBarSlivers(context),
        body: buildBody(context),
        bottomNavigationBar: buildBottomNavigationBar(context),
        floatingActionButton: const SizedBox.shrink(), // Disabled floating buttons for iOS UI
      ),
    );
  }

  List<Widget> _buildHomeAppBarSlivers(BuildContext context) {
    final enableRelaxSounds = context.read<DevicePreferencesProvider>().enableRelaxSounds;
    return [
      SliverAppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        pinned: true,
        floating: true,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        forceElevated: false,
        expandedHeight: viewModel.scrollInfo.appBar(context).getExpandedHeight(),
        flexibleSpace: _HomeFlexibleSpaceBar(viewModel: viewModel),
        actions: [
          if (kIAPEnabled && enableRelaxSounds)
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(SpIcons.musicNote, size: 18),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  RelaxSoundsRoute().push(context);
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(SpIcons.add, size: 18, color: Theme.of(context).colorScheme.onPrimary),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                _showAddActionSheet(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(SpIcons.setting, size: 18),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                viewModel.openSettings(context);
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(viewModel.scrollInfo.appBar(context).getTabBarPreferredHeight()),
          child: _HomeTabBar(viewModel: viewModel),
        ),
      ),
    ];
  }

  void _showAddActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(tr("button.new_story")),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text(tr("button.new_story")),
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context);
              viewModel.goToNewPage(context);
            },
          ),
          if (kStoryPad && kSupportCamera)
            CupertinoActionSheetAction(
              child: Text(tr("button.take_photo")),
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
                viewModel.takePhoto(context);
              },
            ),
          CupertinoActionSheetAction(
            child: Text(tr("button.record_voice")),
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context);
              viewModel.goToNewPageWithVoice(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(tr("paywall_features.templates.title")),
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context);
              viewModel.goToTemplatePage(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
          },
          child: Text(tr("button.cancel")),
        ),
      ),
    );
  }

  Widget buildEndDrawer(BuildContext context) {
    bool bigScreen = WindowedDetectorService.isBigWindow(context);

    return Drawer(
      width: bigScreen ? 400 : null,
      child: bigScreen ? const SpNestedNavigation(initialScreen: HomeEndDrawer()) : const HomeEndDrawer(),
    );
  }

  Widget buildFloatingButtons(BuildContext context) {
    return SpStoryListMultiEditWrapper.listen(
      context: context,
      builder: (context, state) {
        return Visibility(
          visible: !state.editing,
          child: _HomeFloatingButtons(viewModel: viewModel),
        );
      },
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return SpStoryListMultiEditWrapper.listen(
      context: context,
      builder: (context, state) {
        if (!state.editing) return const SizedBox.shrink();

        List<StoryDbModel> stories = [
          ...viewModel.stories?.items.where((story) {
                return state.selectedStories.contains(story.id);
              }) ??
              [],
          ...viewModel.pinnedStories?.items.where((story) {
                return state.selectedStories.contains(story.id);
              }) ??
              [],
        ];

        bool allPinned = stories.every((story) => story.pinned == true);

        return SpMultiEditBottomNavBar(
          editing: true,
          onCancel: () => state.turnOffEditing(),
          buttons: [
            _PinStoryIconButton(state: state, allPinned: allPinned, stories: stories, viewModel: viewModel),
            IconButton.outlined(
              tooltip: "${tr("button.archive")} (${state.selectedStories.length})",
              icon: const Icon(SpIcons.archive),
              onPressed: stories.isEmpty ? null : () => state.archiveAll(context),
            ),
            IconButton.outlined(
              color: ColorScheme.of(context).error,
              tooltip: "${tr("button.move_to_bin")} (${state.selectedStories.length})",
              icon: const Icon(SpIcons.delete),
              onPressed: stories.isEmpty ? null : () => state.moveToBinAll(context),
            ),
          ],
        );
      },
    );
  }

  Widget buildBody(BuildContext listContext) {
    int itemsCount = viewModel.stories?.items.length ?? 0;

    bool hasPinnedOrThrowback = viewModel.hasPinned || viewModel.hasThrowback;
    if (hasPinnedOrThrowback) itemsCount += 1;

    if (viewModel.stories == null) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    if (itemsCount == 0) {
      return SliverFillRemaining(
        child: _HomeEmpty(viewModel: viewModel),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.only(
        top: 0.0,
        left: MediaQuery.of(listContext).padding.left,
        right: MediaQuery.of(listContext).padding.right,
        bottom: kToolbarHeight + 200 + MediaQuery.of(listContext).padding.bottom,
      ),
      sliver: SliverList.builder(
        itemCount: itemsCount,
        itemBuilder: (context, itemIndex) {
          if (itemIndex == 0 && hasPinnedOrThrowback) {
            return Column(
              children: [
                if (viewModel.hasThrowback)
                  SpThrowbackTile(
                    listHasStories: viewModel.stories?.items.isNotEmpty == true,
                    throwbackDates: viewModel.throwbackDates,
                  ),
                for (int pinnedIndex = 0; pinnedIndex < (viewModel.pinnedStories?.items.length ?? 0); pinnedIndex++)
                  buildStoryTile(
                    index: pinnedIndex,
                    context: context,
                    listContext: listContext,
                    stories: viewModel.pinnedStories!,
                    eligibleToShowRecap: false,
                  ),
              ],
            );
          }

          int storyIndex = itemIndex;
          if (hasPinnedOrThrowback) storyIndex = itemIndex - 1;

          return buildStoryTile(
            index: storyIndex,
            context: context,
            listContext: listContext,
            stories: viewModel.stories!,
            eligibleToShowRecap: true,
          );
        },
      ),
    );
  }

  Widget buildStoryTile({
    required int index,
    required BuildContext context,
    required BuildContext listContext,
    required CollectionDbModel<StoryDbModel> stories,
    required bool eligibleToShowRecap,
  }) {
    StoryDbModel story = stories.items[index];

    return SpStoryListenerBuilder(
      key: viewModel.scrollInfo.getKeyForStoryIndex(story.pinned, index),
      story: story,
      onChanged: (StoryDbModel updatedStory) => viewModel.onAStoryReloaded(updatedStory),
      onDeleted: () => viewModel.onAStoryDeleted(story),
      builder: (_) {
        return Stack(
          children: [
            Positioned.fill(
              child: ValueListenableBuilder(
                valueListenable: viewModel.scrollInfo.scrollingToStoryIdNotifier,
                builder: (context, storyId, child) {
                  return AnimatedContainer(
                    duration: Durations.long4,
                    color: storyId == story.id ? ColorScheme.of(context).readOnly.surface5 : Colors.transparent,
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            SpStoryTileListItem(
              listHasPinned: viewModel.hasPinned,
              showYear: false,
              index: index,
              stories: stories,
              onTap: () => viewModel.goToViewPage(context, story),
              listContext: listContext,
              listHasThrowback: viewModel.hasThrowback,
              monthlyStats: eligibleToShowRecap ? viewModel.monthlyStats : null,
            ),
          ],
        );
      },
    );
  }
}
