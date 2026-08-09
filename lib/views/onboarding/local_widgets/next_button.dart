part of "../onboarding_view.dart";

class _NextButton extends StatelessWidget {
  const _NextButton({
    required this.viewModel,
  });

  final OnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: Theme.of(context).colorScheme.primary,
        disabledColor: Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(14), // Modern iOS prominent button radius
        onPressed: () => viewModel.next(context),
        child: Text(
          tr("button.next"),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.white,
          ),
        ),
      ),
    );
  }
}
