part of '../home_view.dart';

class _HomeEmpty extends StatelessWidget {
  const _HomeEmpty({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    String message = tr(
      'page.home.empty_message',
      namedArgs: {
        "YEAR": viewModel.year.toString(),
      },
    );

    return SingleChildScrollView(
      child: SizedBox(
        height:
            MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            viewModel.scrollInfo.appBar(context).getExpandedHeight() -
            MediaQuery.of(context).padding.bottom,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SpTapEffect(
              effects: const [
                SpTapEffectType.touchableOpacity,
                SpTapEffectType.scaleDown,
              ],
              onTap: () {
                HapticFeedback.selectionClick();
                viewModel.goToNewPage(context);
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: SpLoopAnimationBuilder(
                  loopCount: 0, // Infinite loop
                  duration: const Duration(seconds: 1),
                  reverseDuration: const Duration(seconds: 1),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 1.0 + (value * 0.2), // Scale up to 1.2x
                      child: Icon(
                        SpIcons.add,
                        size: 36.0,
                        color: ColorScheme.of(context).primary,
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + kToolbarHeight),
              child: Text.rich(
                textAlign: TextAlign.center,
                textScaler: MediaQuery.textScalerOf(context),
                TextSpan(
                  style: TextTheme.of(context).bodyLarge,
                  children: [
                    TextSpan(text: message.split("{EDIT_BUTTON}").first),
                    const WidgetSpan(
                      child: Icon(SpIcons.add, size: 16.0),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(text: message.split("{EDIT_BUTTON}").last),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
