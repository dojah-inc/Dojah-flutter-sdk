import 'package:dojah_kyc_sdk_flutter/dojah_kyc_sdk_flutter_platform_interface.dart';

import 'dojah_extra_flutter_data.dart';

class DojahKyc {
  static Future<String?> launch(String widgetId,
      {String? referenceId, String? email, ExtraUserData? extraUserData}) {
    return DojahFlutterSdkPlatform.instance.launchDojah(
      widgetId,
      referenceId: referenceId,
      email: email,
      extraData: extraUserData,
    );
  }
}
