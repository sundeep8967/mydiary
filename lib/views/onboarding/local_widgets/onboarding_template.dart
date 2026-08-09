import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storypad/widgets/sp_fade_in.dart';

class OnboardingTemplate extends StatelessWidget {
  const OnboardingTemplate({
    super.key,
    required this.title,
    required this.description,
    required this.actionButton,
    required this.demo,
    required this.currentStep,
    required this.maxStep,
    required this.onSkip,
    this.fadeInContent = false,
  });

  final String title;
  final String description;
  final Widget? demo;
  final Widget actionButton;
  final int currentStep;
  final int maxStep;
  final bool fadeInContent;
  final void Function()? onSkip;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return buildScaffold(context, constraints);
      },
    );
  }

  Widget buildScaffold(BuildContext context, BoxConstraints constraints) {
    double staturBarHeight = MediaQuery.of(context).padding.top;
    double bottomBarHeight = MediaQuery.of(context).padding.bottom + 24;

    double dividerHeight = demo == null ? 0 : 1;
    double spacingBetweenSection = 56;
    double demoHeight = demo == null ? 240 : 360.0 + 48.0;

    double pageHeight = MediaQuery.of(context).size.height;
    double contentHeight =
        pageHeight - (staturBarHeight + bottomBarHeight + dividerHeight + spacingBetweenSection + demoHeight);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        leading: ModalRoute.of(context)?.canPop == true
            ? const Hero(tag: 'onboarding-back-button', child: BackButton())
            : null,
        actions: [
          if (onSkip != null)
            Hero(
              tag: 'onboarding-skip-button',
              child: TextButton(
                onPressed: onSkip,
                child: Text(tr("button.skip")),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.only(
          top: staturBarHeight,
          bottom: bottomBarHeight,
        ),
        child: Column(
          children: [
            Container(
              height: demoHeight,
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: GestureDetector(
                onTap: () => HapticFeedback.selectionClick(),
                child: demo,
              ),
            ),
            if (demo != null)
              Hero(
                tag: "onboarding-divider",
                child: Divider(height: dividerHeight),
              ),
            SizedBox(height: spacingBetweenSection),
            Container(
              width: double.infinity,
              height: max(200, contentHeight),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTextPresentation(context),
                  buildFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextPresentation(BuildContext context) {
    final titleText = Text(
      title,
      style: TextTheme.of(context).headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: -0.4,
      ),
      textAlign: TextAlign.center,
    );

    final descriptionText = Container(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Text(
        description,
        style: TextTheme.of(context).bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          [
            titleText,
            const SizedBox(height: 12),
            descriptionText,
          ].asMap().entries.map((entry) {
            return SpFadeIn.fromTop(
              delay: Durations.medium4 + Durations.medium1 * entry.key,
              duration: Durations.long3,
              child: entry.value,
            );
          }).toList(),
    );
  }

  Widget buildFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (currentStep != maxStep) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(maxStep, (index) {
              final isActive = (index + 1) == currentStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 8.0,
                width: isActive ? 28.0 : 8.0,
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              );
            }),
          ),
          const SizedBox(height: 32.0),
        ],
        actionButton,
      ],
    );
  }
}
