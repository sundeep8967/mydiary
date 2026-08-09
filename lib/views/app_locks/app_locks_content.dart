part of 'app_locks_view.dart';

class _AppLocksContent extends StatelessWidget {
  const _AppLocksContent(this.viewModel);

  final AppLocksViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppLockProvider>(context);
    final biometricTile = buildBiometricTile(context: context, provider: provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr("page.app_lock.title")),
      ),
      body: ListView(
        children: [
          CupertinoListSection.insetGrouped(
            children: [
              CupertinoListTile.notched(
                leading: const Icon(SpIcons.lock),
                title: Text(tr('general.pin')),
                subtitle: provider.appLock.pin != null
                    ? Text(List.generate(provider.appLock.pin!.length, (e) => "*").join())
                    : null,
                trailing: CupertinoSwitch(
                  value: provider.appLock.pin != null,
                  onChanged: (value) => provider.togglePIN(context),
                ),
              ),
              if (biometricTile != null) biometricTile,
              CupertinoListTile.notched(
                title: Text(
                  tr("page.security_questions.title"),
                  style: TextStyle(
                    color: provider.appLock.pin != null
                        ? null
                        : Theme.of(context).disabledColor,
                  ),
                ),
                subtitle: Text(tr("page.security_questions.info")),
                leading: Icon(
                  SpIcons.lockQuestion,
                  color: provider.appLock.pin != null
                      ? null
                      : Theme.of(context).disabledColor,
                ),
                trailing: const CupertinoListTileChevron(),
                onTap: provider.appLock.pin != null
                    ? () => SecurityQuestionsRoute().push(context)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget? buildBiometricTile({
    required BuildContext context,
    required AppLockProvider provider,
  }) {
    if (provider.localAuth.enrolledBothFingerprintAndFace) {
      return CupertinoListTile.notched(
        leading: const Icon(SpIcons.biometrics),
        title: Text(tr("general.biometrics_lock")),
        trailing: CupertinoSwitch(
          value: provider.appLock.enabledBiometric == true,
          onChanged: (value) => provider.toggleBiometrics(context),
        ),
      );
    } else if (provider.localAuth.enrolledFace) {
      return CupertinoListTile.notched(
        leading: const Icon(SpIcons.faceUnlock),
        title: Text(tr("general.face_unlock")),
        trailing: CupertinoSwitch(
          value: provider.appLock.enabledBiometric == true,
          onChanged: (value) => provider.toggleBiometrics(context),
        ),
      );
    } else if (provider.localAuth.enrolledFingerprint) {
      return CupertinoListTile.notched(
        leading: const Icon(SpIcons.fingerprint),
        title: Text(tr("general.fingerprint")),
        trailing: CupertinoSwitch(
          value: provider.appLock.enabledBiometric == true,
          onChanged: (value) => provider.toggleBiometrics(context),
        ),
      );
    } else if (provider.localAuth.enrolledOtherBiometrics) {
      return CupertinoListTile.notched(
        leading: const Icon(SpIcons.fingerprint),
        title: Text(tr("general.biometrics_lock")),
        trailing: CupertinoSwitch(
          value: provider.appLock.enabledBiometric == true,
          onChanged: (value) => provider.toggleBiometrics(context),
        ),
      );
    }
    return null;
  }
}
