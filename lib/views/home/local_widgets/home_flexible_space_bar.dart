part of '../home_view.dart';

class _HomeFlexibleSpaceBar extends StatelessWidget {
  const _HomeFlexibleSpaceBar({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, appBarConstraints) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          const Color(0xFF1E293B).withValues(alpha: 0.85),
                          const Color(0xFF0F172A).withValues(alpha: 0.65),
                          colorScheme.surface.withValues(alpha: 0.0),
                        ]
                      : [
                          const Color(0xFFF8FAFC).withValues(alpha: 0.90),
                          const Color(0xFFE2E8F0).withValues(alpha: 0.70),
                          colorScheme.surface.withValues(alpha: 0.0),
                        ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? const Color(0xFF334155).withValues(alpha: 0.3)
                        : const Color(0xFFCBD5E1).withValues(alpha: 0.4),
                    width: 1.0,
                  ),
                ),
              ),
              child: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(
                    left: 16.0 + MediaQuery.of(context).padding.left,
                    right: 16.0 + MediaQuery.of(context).padding.right,
                    bottom:
                        viewModel.scrollInfo.appBar(context).getTabBarPreferredHeight() +
                        viewModel.scrollInfo.appBar(context).contentsMarginBottom,
                  ),
                  child: Stack(
                    children: [
                      buildGreetingMessage(context, appBarConstraints),
                      buildYear(context, appBarConstraints),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildGreetingMessage(BuildContext context, BoxConstraints appBarConstraints) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: AppTheme.getDirectionValue(
        context,
        viewModel.scrollInfo.appBar(context).getYearSize(appBarConstraints).width + 8.0,
        0.0,
      ),
      right: AppTheme.getDirectionValue(
        context,
        0.0,
        viewModel.scrollInfo.appBar(context).getYearSize(appBarConstraints).width + 8.0,
      ),
      child: SpTapEffect(
        onTap: () => context.read<NicknameProvider>().changeName(context),
        child: Container(
          alignment: AppTheme.getDirectionValue(context, Alignment.bottomRight, Alignment.bottomLeft),
          child: SpMeasureSize(
            onPerformLayout: (p0) {
              double actualHeight = p0.height;
              double caculatedHeight = viewModel.scrollInfo.appBar(context).getContentsHeight();

              // for adaptive text to font scaling, we precaculate the contents heights.
              // sometime when font is bigger, this question text render 2 line of text instead of 1.
              // our caculation is wrong because we only caculate for 1 line.
              //
              // because our render align all element to bottom, so it still responsive but just all text is getting near status bar or below it.
              // our solution is to just check how much we caculate wrong, add expanded height it a bit more.
              if (actualHeight > caculatedHeight && actualHeight - caculatedHeight > 1) {
                Future.microtask(() {
                  viewModel.scrollInfo.setExtraExpandedHeight(actualHeight - caculatedHeight);
                });
              } else {
                Future.microtask(() {
                  viewModel.scrollInfo.setExtraExpandedHeight(0);
                });
              }
            },
            child: const Wrap(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 2.0,
                  children: [
                    _HomeAppBarNickname(),
                    _HomeAppBarMessage(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildYear(
    BuildContext context,
    BoxConstraints appBarConstraints,
  ) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 56.0,
      bottom: 0,
      left: AppTheme.getDirectionValue(context, 16.0, null),
      right: AppTheme.getDirectionValue(context, null, 16.0),
      child: Container(
        alignment: AppTheme.getDirectionValue(context, Alignment.bottomLeft, Alignment.bottomRight),
        width: viewModel.scrollInfo.appBar(context).getYearSize(appBarConstraints).width,
        height: viewModel.scrollInfo.appBar(context).getYearSize(appBarConstraints).height,
        margin: viewModel.scrollInfo.extraExpandedHeight > 0 ? const EdgeInsets.only(bottom: 8.0) : null,
        child: SpTapEffect(
          effects: const [SpTapEffectType.touchableOpacity],
          onTap: () => viewModel.openYearsView(context),
          child: FittedBox(
            child: Text(
              viewModel.year.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextTheme.of(context).displayLarge?.copyWith(color: Theme.of(context).disabledColor, height: 1.0),
              textAlign: TextAlign.end,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
