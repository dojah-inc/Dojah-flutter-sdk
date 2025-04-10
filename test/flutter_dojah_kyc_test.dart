import 'package:dojah_kyc_sdk_flutter/dojah_kyc_sdk_flutter.dart';
import 'package:dojah_kyc_sdk_flutter/dojah_kyc_sdk_flutter_method_channel.dart';
import 'package:dojah_kyc_sdk_flutter/dojah_kyc_sdk_flutter_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDojahFlutterSdkPlatform
    with MockPlatformInterfaceMixin
    implements DojahFlutterSdkPlatform {

  @override
  Future<String?> launchDojah(String widgetId,
      {String? referenceId, String? email}) => Future.value('42');
}

void main() {
  final DojahFlutterSdkPlatform initialPlatform = DojahFlutterSdkPlatform.instance;

  test('$MethodChannelDojahFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDojahFlutterSdk>());
  });

  test('getPlatformVersion', () async {
    MockDojahFlutterSdkPlatform fakePlatform = MockDojahFlutterSdkPlatform();
    DojahFlutterSdkPlatform.instance = fakePlatform;

    expect(await DojahKyc.launch(""), '42');
  });
}
