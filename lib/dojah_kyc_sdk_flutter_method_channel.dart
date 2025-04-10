import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dojah_kyc_sdk_flutter_platform_interface.dart';

/// An implementation of [DojahFlutterSdkPlatform] that uses method channels.
class MethodChannelDojahFlutterSdk extends DojahFlutterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dojah_kyc_sdk_flutter');

  @override
  Future<String?> launchDojah(String widgetId,
      {String? referenceId, String? email}) async {
    final result = await methodChannel
        .invokeMethod<String>('launch-dojah', <String, dynamic>{
      'widget_id': widgetId,
      'reference_id': referenceId,
      'email': email,
    });
    return result;
  }
}
