package com.dojah.flutter_dojah_kyc

import android.content.Context
import androidx.annotation.NonNull
import com.dojah_inc.dojah_android_sdk.DojahSdk

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DojahFlutterSdkPlugin */
class DojahFlutterSdkPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_dojah_kyc")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "launch-dojah") {

            try {
                val widgetId = call.argument<String>("widget_id")
                val referenceId = call.argument<String>("reference_id")
                val email = call.argument<String>("email")
                DojahSdk.with(context).launch(widgetId!!, referenceId, email)
                result.success("Success")
            } catch (e: Exception) {
                result.success(e.message)
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
