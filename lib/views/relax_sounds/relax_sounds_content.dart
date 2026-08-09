part of 'relax_sounds_view.dart';

class _RelaxSoundsContent extends StatefulWidget {
  const _RelaxSoundsContent(this.viewModel);

  final RelaxSoundsViewModel viewModel;

  @override
  State<_RelaxSoundsContent> createState() => _RelaxSoundsContentState();
}

class _RelaxSoundsContentState extends State<_RelaxSoundsContent> {
  int _selectedTabIndex = 0;

  void _onTabChanged(int index) {
    if (index == 1 && !context.read<InAppPurchaseProvider>().isProUser) {
      const PaywallRoute(initialFocus: .relax_sounds).push(context);
      return;
    }
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: !CupertinoSheetRoute.hasParentSheet(context),
        actions: [
          if (CupertinoSheetRoute.hasParentSheet(context))
            CloseButton(onPressed: () => CupertinoSheetRoute.popSheet(context)),
        ],
        title: CupertinoSlidingSegmentedControl<int>(
          groupValue: _selectedTabIndex,
          children: {
            0: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                tr('general.sounds'),
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
            1: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Consumer<InAppPurchaseProvider>(
                builder: (context, iapProvider, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tr('general.sound_mixes'),
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      if (!iapProvider.isProUser) ...[
                        const SizedBox(width: 4.0),
                        const Icon(SpIcons.lock, size: 14.0),
                      ],
                    ],
                  );
                },
              ),
            ),
          },
          onValueChanged: (value) {
            if (value != null) {
              _onTabChanged(value);
            }
          },
        ),
      ),
      bottomNavigationBar: SpFloatingRelaxSoundsTile(
        onSaveMix: (context) async {
          widget.viewModel.saveMix(context);
        },
      ),
      body: IndexedStack(
        index: _selectedTabIndex,
        children: [
          _SoundsTab(viewModel: widget.viewModel),
          _MixesTab(viewModel: widget.viewModel),
        ],
      ),
    );
  }
}
