# Dojah KYC SDK (Flutter)


## Installation

```sh
 $ flutter pub add flutter_dojah_kyc
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
import 'package:flutter_dojah_kyc/flutter_dojah_kyc.dart';

DojahKyc.launch(
  "{Required: Your_WidgetID}",
  referenceId: "{Optional: Reference_ID}",
  email: "{Optional: Email_Address}”
)

```

### SDK Parameters
- `WidgetID` - a `REQUIRED` parameter. You get this ID when you sign up on the Dojah platform, follow the next step to generate your WidgetId.
- `Reference ID` - an `OPTIONAL` parameter that allows you to initialize the SDK for an ongoing verification.
- `Email Address` - an `OPTIONAL` parameter that allows you to initialize the SDK for an ongoing verification.

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
