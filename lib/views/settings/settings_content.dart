part of 'settings_view.dart';

class _SettingsContent extends StatelessWidget {
  const _SettingsContent(this.viewModel);

  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(tr("page.settings.title")),
            trailing: SpPopupMenuButton(
              items: (context) {
                return [
                  SpPopMenuItem(
                    leadingIconData: SpIcons.refresh,
                    title: tr("button.reset"),
                    onPressed: () {
                      context.read<DevicePreferencesProvider>().reset();
                    },
                  ),
                ];
              },
              builder: (callback) {
                return CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: callback,
                  child: const Icon(SpIcons.moreVert),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),
              CupertinoListSection.insetGrouped(
                header: Text(tr("general.appearance")),
                children: [
                  ColorSeedTile(),

                ],
              ),
              CupertinoListSection.insetGrouped(
                header: Text(tr("general.text")),
                children: [
                  FontSizeTile.globalTheme(weekday: 3),
                  FontFamilyTile.globalTheme(weekday: 4),
                  FontWeightTile.globalTheme(weekday: 5),
                ],
              ),
              CupertinoListSection.insetGrouped(
                header: Text(tr("general.general")),
                children: [
                  const LanguageTile(weekday: 6),
                  buildAppLockTile(context, weekday: 7),
                  if (kSupportQuickActions) QuickActionsTile(),
                  TimeFormatTile.globalTheme(weekday: 2),
                  FirstDayOfWeekTile.globalTheme(weekday: 3),
                ],
              ),
              CupertinoListSection.insetGrouped(
                header: Text(tr("general.stories")),
                children: [
                  StoryTilePreferencesTile(weekday: 4),
                  DefaultStoryPreferencesTile(weekday: 5),
                ],
              ),
              CupertinoListSection.insetGrouped(
                header: Text(tr("general.data")),
                children: [
                  CupertinoListTile.notched(
                    leading: const SpSettingIconBadge(weekday: 6, icon: SpIcons.googleDrive),
                    title: Text(tr('page.backup_services.title')),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => const BackupServicesRoute().push(context),
                  ),
                  CupertinoListTile.notched(
                    leading: const SpSettingIconBadge(weekday: 7, icon: SpIcons.folderOpen),
                    title: Text(tr('page.import_export_backup')),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => const ImportExportRoute().push(context),
                  ),
                  CupertinoListTile.notched(
                    leading: const SpSettingIconBadge(weekday: 1, icon: SpIcons.storage),
                    title: Text(tr('page.storage_management.title')),
                    trailing: const CupertinoListTileChevron(),
                    onTap: () => const StorageManagementRoute().push(context),
                  ),
                  AssetCompressionTile.globalTheme(weekday: 2),
                ],
              ),
              const SizedBox(height: 120),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildAppLockTile(BuildContext context, {int weekday = 2}) {
    return Consumer<AppLockProvider>(
      builder: (context, appLockProvider, child) {
        return CupertinoListTile.notched(
          leading: SpSettingIconBadge(weekday: weekday, icon: SpIcons.lock),
          title: Text(tr("page.app_lock.title")),
          subtitle: appLockProvider.hasAppLock ? Text(tr("general.enabled")) : null,
          trailing: const CupertinoListTileChevron(),
          onTap: () => AppLocksRoute().push(context),
        );
      },
    );
  }
}
