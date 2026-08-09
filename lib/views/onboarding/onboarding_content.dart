part of 'onboarding_view.dart';

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent(this.viewModel);

  final OnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorScheme.primaryContainer.withValues(alpha: 0.4),
                colorScheme.surface,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top AppBar action
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                    child: IconButton(
                      tooltip: tr('page.language.title'),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(SpIcons.globe, size: 20),
                      ),
                      onPressed: () => LanguagesRoute(
                        showBetaBanner: false,
                        showThemeFAB: true,
                        fromOnboarding: true,
                      ).push(context),
                    ),
                  ),
                ),
                
                // Hero Presentation Section
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SpFadeIn.fromTop(
                            duration: Durations.long2,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withValues(alpha: 0.15),
                                    blurRadius: 32,
                                    spreadRadius: 4,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: kAppLogo!.asset.image(width: 88, height: 88),
                            ),
                          ),
                          const SizedBox(height: 28),
                          SpFadeIn.fromTop(
                            delay: Durations.medium1,
                            duration: Durations.long3,
                            child: Text(
                              'Welcome to My Diary',
                              style: TextTheme.of(context).headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.8,
                                color: colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SpFadeIn.fromTop(
                            delay: Durations.medium2,
                            duration: Durations.long3,
                            child: Text(
                              'Your personal, private journal for thoughts & memories.',
                              style: TextTheme.of(context).bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Sleek Bottom Input Card
                SpFadeIn.fromBottom(
                  delay: Durations.medium3,
                  duration: Durations.long4,
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 480),
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.08),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tr('dialog.what_should_i_call_you.title'),
                          style: TextTheme.of(context).titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tr('dialog.what_should_i_call_you.message'),
                          style: TextTheme.of(context).bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _NicknameField(viewModel: viewModel),
                        const SizedBox(height: 20),
                        _NextButton(viewModel: viewModel),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
