import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dojah_flutter_sdk/dojah_flutter_sdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDojahFlutterSdk platform = MethodChannelDojahFlutterSdk();
  const MethodChannel channel = MethodChannel('dojah_flutter_sdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.launchDojah(""), '42');
  });
}
