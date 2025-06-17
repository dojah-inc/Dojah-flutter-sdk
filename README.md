# Dojah KYC SDK (Flutter)


## Installation

```sh
 $ flutter pub add dojah_kyc_sdk_flutter
```

## Android Setup

### Requirements
* Minimum Android SDK version - 21
* Supported targetSdkVersion - 35

In your android root/build.gradle file set maven path:
```
...
allprojects {
    repositories {
        ...
        maven { url "https://jitpack.io" }
    }
}
```
Or Set maven path in your root/settings.gradle file:
```
...
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        ...
        maven { url "https://jitpack.io" }
    }
}
```

### Permissions
For Android you don't need to declare permissions, its already included in the Package.

## IOS Setup

### Requirements
* Minimum iOS version - 14

### Add the following POD dependencies in your Podfile app under your App target

```
  pod 'Realm', '~> 10.52.2', :modular_headers => true
  pod 'DojahWidget', :git => 'https://github.com/dojah-inc/sdk-swift.git', :branch => 'pod-package'
```

example
```
target 'Example' do
  ...
  pod 'Realm', '~> 10.52.2', :modular_headers => true
  pod 'DojahWidget', :git => 'https://github.com/dojah-inc/sdk-swift.git', :branch => 'pod-package'
  ...
end
```
and run pod install in your ios folder:
```sh
cd ios
pod install
```


### Permissions
For IOS, Add the following keys to your Info.plist file:

NSCameraUsageDescription - describe why your app needs access to the camera. This is called Privacy - Camera Usage Description in the visual editor.

NSMicrophoneUsageDescription - describe why your app needs access to the microphone, if you intend to record videos. This is called Privacy - Microphone Usage Description in the visual editor.

NSLocationWhenInUseUsageDescription - describe why your app needs access to the location, if you intend to verify address/location. This is called Privacy - Location Usage Description in the visual editor.



## Usage

To start KYC, import Dojah in your React Native code, and launch Dojah Screen

```dart
import 'package:dojah_kyc_sdk_flutter/dojah_kyc_sdk_flutter.dart';

DojahKyc.launch(
  "{Required: Your_WidgetID}",
  referenceId: "{Optional: Reference_ID}",
  email: "{Optional: Email_Address}”,
  //Optional data for custom verification
  extraUserData: ExtraUserData(
    userData: UserData(firstName: "Enter FirstName",lastName: "Enter LastName",dob: "dd-mm-yyyy"),
    govData: GovData(bvn: "Enter BVN"),
    govId: GovId(national: "link to the national id image"),
    location: Location(latitude: "Enter Latitude",longitude: "Enter Longitude"),
    businessData: BusinessData(cac: "Enter CAC Number"),
    address: "Enter Address",
    metadata: {"custom_key": "custom_value"},
  )
)

```

### SDK Parameters
- `WidgetID` - a `REQUIRED` parameter. You get this ID when you sign up on the Dojah platform, follow the next step to generate your WidgetId.
- `Reference ID` - an `OPTIONAL` parameter that allows you to initialize the SDK for an ongoing verification.
- `Email Address` - an `OPTIONAL` parameter that allows you to initialize the SDK for an ongoing verification.
- `ExtraUserData` - an `OPTIONAL` parameter that allows you to pass custom data to the SDK.

## How to Get a Widget ID
To use the SDK, you need a WidgetID, which is a required parameter for initializing the SDK. You can obtain this by creating a flow on the Dojah platform. Follow these steps to configure and get your Widget ID:

```txt
1. Log in to your Dojah Dashboard: If you don’t have an account, sign up on the Dojah platform.

2. Navigate to the EasyOnboard Feature: Once logged in, find the EasyOnboard section on your dashboard.

3. Create a Flow:

    - Click on the 'Create a Flow' button.
    - Name Your Flow: Choose a meaningful name for your flow, which will help you identify it later.

4. Add an Application:

    - Either create a new application or add an existing one.
    - Customise your widget with your brand logo and color by selecting an application.

5. Configure the Flow:

    - Select a Country: Choose the country or countries relevant to your verification process.
    - Select a Preview Process: Decide between automatic or manual verification.
    - Notification Type: Choose how you’d like to receive notifications for updates (email, SMS, etc.).
    - Add Verification Pages: Customize the verification steps in your flow (e.g., ID verification, address verification, etc.).
    
6. Publish Your Widget: After configuring your flow, publish the widget. Once published, your flow is live.

7. Copy Your Widget ID: After publishing, the platform will generate a Widget ID. Copy this Widget ID as you will need it to initialize the SDK as stated above.
```

## TroubleShooting

### Android ProGuard/R8 Configuration for Release Builds
When building your Android application in release mode with code shrinking (R8/ProGuard) enabled, you might encounter issues where the SDK or its dependencies fail to function correctly. This happens because R8, the default code shrinker, might remove classes or methods that are used by the SDK but aren't explicitly referenced in a way R8 can detect.

If you experience crashes or unexpected behavior related to missing classes (often indicated by errors like ClassNotFoundException or Missing classes detected while running R8), you'll need to add specific "keep" rules to your project's ProGuard configuration.

### How to Apply ProGuard Rules

Locate your ProGuard file: In your Flutter project, navigate to android/app/proguard-rules.pro. If this file doesn't exist, create it.

Add the necessary rules: Open the proguard-rules.pro file and add the following lines. These rules instruct R8 to preserve the essential components of the Dojah SDK and its underlying libraries during the build process.

```
# Dojah SDK Specific Rules
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

-keep class com.dojah.kyc_sdk_kotlin.domain.** { *; }
-keep class com.dojah.kyc_sdk_kotlin.core.Result

-keep interface com.dojah.** { *; }
-keep class com.dojah.dojah_kyc_sdk_flutter.** {*;}
-keep class com.dojah.dojah_kyc_sdk_flutter.DojahFlutterSdkPlugin
-keep class com.dojah.dojah_kyc_sdk_flutter.DojahFlutterSdkPluginKt
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
-keep class * extends io.flutter.plugins.GeneratedPluginRegistrant { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant
-keep class * implements io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback { *; }

# Rules for Retrofit
-keepattributes Signature, InnerClasses, EnclosingMethod
-keepattributes RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations
-keepattributes AnnotationDefault
-keepclassmembers,allowshrinking,allowobfuscation interface * {
    @retrofit2.http.* <methods>;
}
-dontwarn javax.annotation.**
-dontwarn kotlin.Unit
-dontwarn retrofit2.KotlinExtensions
-dontwarn retrofit2.KotlinExtensions$*
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface 
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation

# Rules for Okio
-dontwarn org.codehaus.mojo.animal_sniffer.*

# Rules for Gson
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.examples.android.model.** { *; }

# Rules for Glide
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep class * extends com.bumptech.glide.module.AppGlideModule {
 <init>(...);
}
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}
-keep class com.bumptech.glide.load.data.ParcelFileDescriptorRewinder$InternalRewinder {
  *** rewind();
}

# Dontwarn rules for Play Core Library (if used)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Dontwarn rules for specific classes often linked with network/security
-dontwarn com.android.org.conscrypt.SSLParametersImpl
-dontwarn javax.naming.Binding
-dontwarn javax.naming.NamingEnumeration
-dontwarn javax.naming.NamingException
-dontwarn javax.naming.directory.Attribute
-dontwarn javax.naming.directory.Attributes
-dontwarn javax.naming.directory.DirContext
-dontwarn javax.naming.directory.InitialDirContext
-dontwarn javax.naming.directory.SearchControls
-dontwarn javax.naming.directory.SearchResult
-dontwarn org.apache.harmony.xnet.provider.jsse.SSLParametersImpl
-dontwarn org.bouncycastle.jsse.BCSSLParameters
-dontwarn org.bouncycastle.jsse.BCSSLSocket
-dontwarn org.bouncycastle.jsse.provider.BouncyCastleJsseProvider
-dontwarn org.openjsse.javax.net.ssl.SSLParameters
-dontwarn org.openjsse.javax.net.ssl.SSLSocket
-dontwarn org.openjsse.net.ssl.OpenJSSE
-dontwarn io.grpc.internal.DnsNameResolverProvider
-dontwarn io.grpc.internal.PickFirstLoadBalancerProvider
-dontwarn org.bouncycastle.jsse.BCSSLParameters
-dontwarn org.bouncycastle.jsse.BCSSLSocket
-dontwarn org.bouncycastle.jsse.provider.BouncyCastleJsseProvider
-dontwarn org.conscrypt.Conscrypt$Version
-dontwarn org.conscrypt.Conscrypt
```

Ensure ProGuard is enabled: Verify that proguardFiles is pointing to the default Android ProGuard rules and your custom proguard-rules.pro file. This tells R8 to use your added rules.
Your release build type block should look similar to this:

``` groovy
android {
    buildTypes {
        release {
            // ... other configurations like signingConfig
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```
