import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storypad/core/constants/locale_constants.dart';
import 'package:storypad/views/languages/languages_view.dart';
import 'package:storypad/widgets/sp_icons.dart';
import 'package:storypad/widgets/sp_setting_icon_badge.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({
    super.key,
    required this.weekday,
  });

  final int weekday;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      onTap: () => LanguagesRoute().push(context),
      leading: SpSettingIconBadge(weekday: weekday, icon: SpIcons.globe),
      subtitle: Text(kNativeLanguageNames[context.locale.toLanguageTag()]!),
      trailing: const CupertinoListTileChevron(),
      title: Text(tr("page.language.title")),
    );
  }
}
