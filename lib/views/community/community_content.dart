part of 'community_view.dart';

class _CommunityContent extends StatelessWidget {
  const _CommunityContent(this.viewModel);

  final CommunityViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(tr('page.community.title')),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).padding.left,
          right: MediaQuery.of(context).padding.right,
        ),
        children: [
          const _CommunityCard(),

          CupertinoListSection.insetGrouped(
            children: [
              if (RemoteConfigService.policyPrivacyUrl.get().trim().isNotEmpty == true)
                CupertinoListTile.notched(
                  leading: const Icon(SpIcons.policy),
                  title: Text(tr("general.privacy_policy")),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => UrlOpenerService.openInCustomTab(context, RemoteConfigService.policyPrivacyUrl.get()),
                ),
              CupertinoListTile.notched(
                leading: const Icon(SpIcons.onboarding),
                title: Text(tr('general.onboard_page')),
                trailing: const CupertinoListTileChevron(),
                onTap: () async {
                  if (Scaffold.maybeOf(context)?.hasEndDrawer == true) {
                    Scaffold.of(context).closeEndDrawer();
                    SpOnboardingWrapper.open(context);
                  } else {
                    await Navigator.maybePop(context);
                    SpOnboardingWrapper.open(HomeView.homeContext!);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
