part of '../onboarding_view.dart';

class _NicknameField extends StatelessWidget {
  const _NicknameField({
    required this.viewModel,
  });

  final OnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: viewModel.controller.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return '';
        return null;
      },
      builder: (state) {
        final hasError = state.hasError;
        
        return CupertinoTextField(
          controller: viewModel.controller,
          placeholder: tr("input.nickname.hint"),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          clearButtonMode: OverlayVisibilityMode.editing,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          style: TextStyle(
            color: CupertinoDynamicColor.resolve(CupertinoColors.label, context),
            fontSize: 17,
          ),
          placeholderStyle: TextStyle(
            color: CupertinoDynamicColor.resolve(CupertinoColors.placeholderText, context),
            fontSize: 17,
          ),
          decoration: BoxDecoration(
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.secondarySystemFill, 
              context,
            ),
            borderRadius: BorderRadius.circular(10),
            border: hasError 
                ? Border.all(color: CupertinoColors.destructiveRed, width: 1.5)
                : null,
          ),
          onChanged: state.didChange,
          onSubmitted: (value) => viewModel.next(context),
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        );
      },
    );
  }
}
