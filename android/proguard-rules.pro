-keep class * extends io.flutter.plugin.common.PluginRegistry {
    public *;
}

-keep class com.dojah.dojah_kyc_sdk_flutter.** {*;}
-keep class com.dojah.dojah_kyc_sdk_flutter.DojahFlutterSdkPlugin
-keep class com.dojah.dojah_kyc_sdk_flutter.DojahFlutterSdkPluginKt
-keep interface com.dojah.** { *; }

-keep class io.flutter.plugins.** { *; }

# Keep gRPC classes
-keep class io.grpc.** { *; }

# Keep BouncyCastle classes
-keep class org.bouncycastle.** { *; }

# Keep Conscrypt classes
-keep class org.conscrypt.** { *; }

# Keep OpenJSSE classes
-keep class org.openjsse.** { *; }

# General Flutter plugin preservation
-keep class * extends io.flutter.plugin.common.PluginRegistry { *; }
-keep class * extends io.flutter.plugins.** { *; }
-keep class * implements io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback { *; }

