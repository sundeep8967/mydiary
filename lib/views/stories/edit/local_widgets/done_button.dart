part of '../edit_story_view.dart';

class _DoneButton extends StatelessWidget {
  const _DoneButton({
    required this.viewModel,
  });

  final EditStoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: viewModel.lastSavedAtNotifier,
      builder: (_, lastSavedAt, child) {
        bool disabled = lastSavedAt == null;
        return Visibility(
          visible:
              (viewModel.flowType == EditingFlowType.create && lastSavedAt != null) ||
              (viewModel.flowType == EditingFlowType.update),
          child: SpFadeIn.bound(
            child: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              onPressed: disabled ? null : () => viewModel.done(context),
              child: Text(
                tr("button.done"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: disabled
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
