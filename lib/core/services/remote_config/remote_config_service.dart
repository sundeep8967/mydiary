import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:storypad/core/constants/app_constants.dart';

part './remote_config_object.dart';

class RemoteConfigService {
  final List<_RemoteConfigObject> _registeredKeys = [
    alternativeToUrl,
    bugReportUrl,
    featureFlags,
    localizationSupportUrl,
    policyPrivacyUrl,
    productHuntUrl,
    redditUrl,
    sourceCodeUrl,
    relaxSoundFreeSetVariant,
    surveyUrl,
    tiktokUsername,
    twitterUrl,
    websiteUrl,
  ];

  static final instance = RemoteConfigService._();
  RemoteConfigService._();

  final Map<Type, void Function()> _listeners = {};
  void clearListeners(String key, void Function() callback) => _listeners.clear();
  void notifyListeners() {
    for (var callback in _listeners.values) {
      callback.call();
    }
  }

  void addListener(Type key, void Function() callback) {
    _listeners[key] = callback;
  }

  static const alternativeToUrl = _RemoteConfigObject<String>(
    'ALTERNATIVE_TO_URL',
    _RemoteConfigValueType.string,
    '',
  );

  static const bugReportUrl = _RemoteConfigObject<String>(
    'BUG_REPORT_URL',
    _RemoteConfigValueType.string,
    '',
  );

  static const featureFlags = _RemoteConfigObject<Map>(
    'FEATURE_FLAGS',
    _RemoteConfigValueType.json,
    {},
  );

  static const localizationSupportUrl = _RemoteConfigObject<String>(
    'LOCALIZATION_SUPPORT_URL',
    _RemoteConfigValueType.string,
    '',
  );

  static const policyPrivacyUrl = _RemoteConfigObject<String>(
    'POLICY_PRIVACY_URL',
    _RemoteConfigValueType.string,
    '',
  );

  static const productHuntUrl = _RemoteConfigObject<String>(
    'PRODUCT_HUNT_URL',
    _RemoteConfigValueType.string,
    '',
  );

  static const redditUrl = _RemoteConfigObject<String>(
    'REDDIT_URL',
    _RemoteConfigValueType.string,
    '',
  );

  static const sourceCodeUrl = _RemoteConfigObject<String>(
    'SOURCE_CODE_URL',
    _RemoteConfigValueType.string,
    'https://github.com/sundeep8967/mydiary',
  );

  static const relaxSoundFreeSetVariant = _RemoteConfigObject<String>(
    'RELAX_SOUND_FREE_SET_VARIANT',
    _RemoteConfigValueType.string,
    'variant_1',
  );

  static const surveyUrl = _RemoteConfigObject<String>(
    'SURVEY_URL',
    _RemoteConfigValueType.string,
    '',
  );

  static const tiktokUsername = _RemoteConfigObject<String>(
    'TIKTOK_USERNAME',
    _RemoteConfigValueType.string,
    '',
  );

  static const twitterUrl = _RemoteConfigObject<String>(
    'TWITTER_URL',
    _RemoteConfigValueType.string,
    '',
  );

  static const websiteUrl = _RemoteConfigObject<String>(
    'WEBSITE_URL',
    _RemoteConfigValueType.string,
    '',
  );

  Future<void> initialize() async {
    final defaults = {
      for (final element in _registeredKeys)
        element.key: element.defaultValue is Map ? jsonEncode(element.defaultValue) : element.defaultValue,
    };

    await kRemoteConfigAdaptor.initialize(defaults);
    notifyListeners();

    kRemoteConfigAdaptor.onConfigUpdated.listen(
      (updatedKeys) {
        debugPrint(updatedKeys.toString());
        notifyListeners();
      },
      onError: (error) {
        debugPrint(error.toString());
      },
    );
  }
}
