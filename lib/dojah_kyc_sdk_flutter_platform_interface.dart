import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dojah_extra_flutter_data.dart';
import 'dojah_kyc_sdk_flutter_method_channel.dart';

abstract class DojahFlutterSdkPlatform extends PlatformInterface {
  /// Constructs a DojahFlutterSdkPlatform.
  DojahFlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static DojahFlutterSdkPlatform _instance = MethodChannelDojahFlutterSdk();

  /// The default instance of [DojahFlutterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelDojahFlutterSdk].
  static DojahFlutterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DojahFlutterSdkPlatform] when
  /// they register themselves.
  static set instance(DojahFlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> launchDojah(String widgetId,
      {String? referenceId, String? email,ExtraUserData? extraData}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
