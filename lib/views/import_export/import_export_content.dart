part of 'import_export_view.dart';

class _ImportExportContent extends StatelessWidget {
  const _ImportExportContent(this.viewModel);

  final ImportExportViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('page.import_export_backup')),
      ),
      body: ListView(
        children: [
          CupertinoListSection.insetGrouped(
            header: Text(tr('general.import')),
            children: [
              CupertinoListTile.notched(
                leading: const Icon(SpIcons.importOffline),
                title: Text(tr('list_tile.import_storypad_json.title')),
                onTap: () => viewModel.import(context),
              ),
              CupertinoListTile.notched(
                leading: const Icon(SpIcons.photo),
                title: const Text('Import Media (.tar.gz)'),
                onTap: () => viewModel.importMedia(context),
              ),
            ],
          ),
          _ExportSection(viewModel: viewModel),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.0),
        ],
      ),
    );
  }
}
