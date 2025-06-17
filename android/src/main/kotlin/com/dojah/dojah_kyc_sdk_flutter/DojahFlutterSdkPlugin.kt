package com.dojah.dojah_kyc_sdk_flutter

import android.app.Activity
import android.app.Activity.RESULT_OK
import android.app.Instrumentation
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import com.dojah.kyc_sdk_kotlin.DOJAH_CLOSED_RESULT
import com.dojah.kyc_sdk_kotlin.DOJAH_RESULT_KEY
import com.dojah.kyc_sdk_kotlin.DojahSdk
import com.dojah.kyc_sdk_kotlin.domain.BusinessData
import com.dojah.kyc_sdk_kotlin.domain.ExtraUserData
import com.dojah.kyc_sdk_kotlin.domain.GovData
import com.dojah.kyc_sdk_kotlin.domain.GovId
import com.dojah.kyc_sdk_kotlin.domain.Location
import com.dojah.kyc_sdk_kotlin.domain.UserData

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.io.Serializable

/** DojahFlutterSdkPlugin */
class DojahFlutterSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null
    private var result: Result? = null


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dojah_kyc_sdk_flutter")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        print("onMethodCall -> called!")
        this.result = result
        if (call.method == "launch-dojah") {

            try {
                val widgetId = call.argument<String>("widget_id")
                val referenceId = call.argument<String>("reference_id")
                val email = call.argument<String>("email")
                val extraUserData = call.argument<Map<String, Any>>("extra_user_data")
//                val
                if (activity != null) {
                    DojahSdk.with(context).launchWithBackwardCompatibility(
                        activity!!,
                        widgetId!!,
                        referenceId,
                        email,
                        extraUserData?.let { mapToExtraUserData(it) }?:ExtraUserData()
                    )
                }
//                result.success("Success")
            } catch (e: Exception) {
                result?.success(e.message)
            }
        } else {
            print("NOT_IMPLEMENT -> else case")
            result?.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == 1001) {
            Log.d("DojahFlutterSdkPlugin", "Got Result: $data")
            if (resultCode == RESULT_OK) {
                data?.getStringExtra(DOJAH_RESULT_KEY)?.let {
                    result?.success(it)
                    Log.d("DojahFlutterSdkPlugin", "Got Result: $it")
                }
            } else {
                result?.success(DOJAH_CLOSED_RESULT)
            }
        }

        return false
    }

}

/**
 * Helper function to convert a Map<String, Any?> from Dart
 * into your Kotlin ExtraUserData object.
 */
private fun mapToExtraUserData(map: Map<String, Any?>): ExtraUserData {
    val userDataMap = map["userData"] as? Map<*, *>
    val govDataMap = map["govData"] as? Map<*, *>
    val govIdMap = map["govId"] as? Map<*, *>
    val locationMap = map["location"] as? Map<*, *>
    val businessDataMap = map["businessData"] as? Map<*, *>
    val address = map["address"] as? String
    val metadata = map["metadata"] as? Map<String, Any> // Assuming metadata values are not null

    return ExtraUserData(
        userData = userDataMap?.let {
            UserData(
                firstName = it["first_name"] as? String,
                lastName = it["last_name"] as? String,
                dob = it["dob"] as? String,
                email = it["email"] as? String // This email is inside UserData
            )
        },
        govData = govDataMap?.let {
            GovData(
                bvn = it["bvn"] as? String,
                dl = it["dl"] as? String,
                nin = it["nin"] as? String,
                vnin = it["vnin"] as? String
            )
        },
        govId = govIdMap?.let {
            GovId(
                national = it["national"] as? String,
                passport = it["passport"] as? String,
                dl = it["dl"] as? String, // Note: 'dl' also exists in GovData, ensure correct mapping
                voter = it["voter"] as? String,
                nin = it["nin"] as? String, // Note: 'nin' also exists in GovData
                others = it["others"] as? String
            )
        },
        location = locationMap?.let {
            Location(
                latitude = it["latitude"] as? String,
                longitude = it["longitude"] as? String
            )
        },
        businessData = businessDataMap?.let {
            BusinessData(
                cac = it["cac"] as? String
            )
        },
        address = address,
        metadata = metadata
    )
}
