part of 'languages_view.dart';

class _LanguagesContent extends StatelessWidget {
  const _LanguagesContent(this.viewModel);

  final LanguagesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (viewModel.canSetToDeviceLocale)
            IconButton(
              tooltip: tr("button.reset"),
              icon: const Icon(SpIcons.refresh),
              onPressed: () => viewModel.useDeviceLocale(context),
            ),
        ],
      ),
      bottomNavigationBar: viewModel.params.showBetaBanner ? _FeedbackBanner(context: context) : null,
      floatingActionButton: viewModel.params.showThemeFAB
          ? FloatingActionButton(
              child: const Icon(SpIcons.theme),
              onPressed: () => SettingsRoute(fromOnboarding: viewModel.params.fromOnboarding).push(context),
            )
          : null,
      body: ListView(
        children: [
          CupertinoListSection.insetGrouped(
            children: List.generate(viewModel.supportedLocales.length, (index) {
              return buildLocaleTile(index, context);
            }),
          ),
        ],
      ),
    );
  }

  Widget buildLocaleTile(int index, BuildContext context) {
    final locale = viewModel.supportedLocales.elementAt(index);
    bool selected = context.locale.toLanguageTag() == locale.toLanguageTag();

    return CupertinoListTile.notched(
      key: viewModel.supportedLocaleKeys[index],
      title: Text(kNativeLanguageNames[locale.toLanguageTag()]!),
      trailing: selected
          ? const Icon(
              SpIcons.check,
              color: CupertinoColors.activeBlue,
            )
          : null,
      subtitle: viewModel.isSystemLocale(locale) ? Text(tr('general.default')) : null,
      onTap: () => viewModel.setLocale(locale, context),
    );
  }
}
