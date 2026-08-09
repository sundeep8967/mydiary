part of '../home_view.dart';

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold({
    required this.endDrawer,
    required this.viewModel,
    required this.appBarSlivers,
    required this.body,
    required this.floatingActionButton,
    required this.bottomNavigationBar,
  });

  final HomeViewModel viewModel;
  final Widget? endDrawer;
  final List<Widget> appBarSlivers;
  final Widget body;
  final Widget floatingActionButton;
  final Widget bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: viewModel.scrollInfo.appBar(context).getScaffoldBackgroundColor(context),
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      // For end drawer, we don't use modified padding by root content, we want original screen padding instead
      // because end drawer is on top of content. Plus, left padding is not needed for end drawer.
      endDrawer: endDrawer != null
          ? MediaQuery.removePadding(
              context: RootView.rootContext ?? context,
              removeLeft: true,
              child: endDrawer!,
            )
          : null,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButtonLocation: SpFabLocation.endFloat(context),
      extendBody: true,
      onEndDrawerChanged: (isOpened) {
        if (isOpened) {
          context.read<RootProvider>().setTemporaryHidden(true);
        } else {
          context.read<RootProvider>().setTemporaryHidden(false);
        }
      },
      body: Stack(
        children: [
          RefreshIndicator.adaptive(
            edgeOffset: viewModel.scrollInfo.appBar(context).getExpandedHeight() + MediaQuery.of(context).padding.top,
            onRefresh: () => viewModel.refresh(context),
            child: SpScrollConfiguration(
              child: CustomScrollView(
                controller: viewModel.scrollInfo.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  ...appBarSlivers,
                  body,
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.paddingOf(context).bottom + 12.0,
            child: const _AppUpdateFloatingButton(),
          ),
        ],
      ),
    );
  }
}
