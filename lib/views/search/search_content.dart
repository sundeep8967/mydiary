part of 'search_view.dart';

class _SearchContent extends StatelessWidget {
  const _SearchContent(this.viewModel);

  final SearchViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SpStoryListMultiEditWrapper.withListener(
      builder: (context, state) {
        return PopScope(
          canPop: !state.editing,
          onPopInvokedWithResult: (didPop, result) => viewModel.onPopInvokedWithResult(didPop, result, context),
          child: buildScaffold(context, state),
        );
      },
    );
  }

  Widget buildScaffold(BuildContext context, SpStoryListMultiEditWrapperState state) {
    var visibleTags =
        viewModel.tags?.where((tag) {
          if (tag.id == 0) return true;
          if (tag.storiesCount == null) return false;
          return tag.storiesCount! > 0;
        }).toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !CupertinoSheetRoute.hasParentSheet(context),
        title: CupertinoSearchTextField(
          controller: viewModel.queryController,
          placeholder: tr("input.story_search.hint"),
          placeholderStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 15.0,
          ),
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
            fontSize: 15.0,
          ),
          onChanged: (value) => viewModel.searchText(value),
          onSubmitted: (value) => viewModel.searchText(value),
          onSuffixTap: () => viewModel.clearQuery(context),
        ),
        actions: [
          IconButton(
            tooltip: tr("page.search_filter.title"),
            icon: const Icon(SpIcons.tune),
            onPressed: () => viewModel.goToFilterPage(context),
          ),
          if (CupertinoSheetRoute.hasParentSheet(context))
            CloseButton(onPressed: () => CupertinoSheetRoute.popSheet(context)),
        ],
        bottom: visibleTags.isNotEmpty == true
            ? PreferredSize(
                preferredSize: const Size.fromHeight(34.0 + 12.0),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .start,
                  children: [
                    SizedBox(
                      width: .infinity,
                      child: SpScrollableChoiceChips<TagDbModel>(
                        key: viewModel.tagsChipsKey,
                        choices: visibleTags,
                        storiesCount: (TagDbModel tag) => tag.storiesCount,
                        toLabel: (TagDbModel tag) => tag.title,
                        selected: (TagDbModel tag) => viewModel.tagSelected(tag),
                        onToggle: (TagDbModel tag) => viewModel.toggleTag(tag, context),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ),
              )
            : null,
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, state),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (viewModel.searchFilter == null) return const Center(child: CircularProgressIndicator.adaptive());
    return SpStoryList.withQuery(
      filter: viewModel.searchFilter,
    );
  }

  Widget buildBottomNavigationBar(BuildContext context, SpStoryListMultiEditWrapperState state) {
    return SpMultiEditBottomNavBar(
      editing: state.editing,
      onCancel: () => state.turnOffEditing(),
      buttons: [
        OutlinedButton(
          child: Text("${tr("button.archive")} (${state.selectedStories.length})"),
          onPressed: () => state.archiveAll(context),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: ColorScheme.of(context).error),
          child: Text("${tr("button.move_to_bin")} (${state.selectedStories.length})"),
          onPressed: () => state.moveToBinAll(context),
        ),
      ],
    );
  }
}
