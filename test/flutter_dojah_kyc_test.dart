import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dojah_kyc/flutter_dojah_kyc.dart';
import 'package:flutter_dojah_kyc/flutter_dojah_kyc_platform_interface.dart';
import 'package:flutter_dojah_kyc/flutter_dojah_kyc_method_channel.dart';
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
    DojahKyc dojahFlutterSdkPlugin = DojahKyc();
    MockDojahFlutterSdkPlatform fakePlatform = MockDojahFlutterSdkPlatform();
    DojahFlutterSdkPlatform.instance = fakePlatform;

    expect(await dojahFlutterSdkPlugin.launch(""), '42');
  });
}
