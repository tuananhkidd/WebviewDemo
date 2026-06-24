package com.example.webview_demo

import android.os.Bundle
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Hosts the Flutter UI and bridges the native MethodChannel.
 *
 * Receives the API result (a todo title) from Dart and displays it as a native
 * Android Toast, fulfilling the "toast on the native side" requirement.
 */
class MainActivity : FlutterActivity() {

    // Must match AppConstants.nativeChannel on the Dart side.
    private val channelName = "com.example.webview_demo/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "showToast" -> {
                    val message = call.argument<String>("message").orEmpty()
                    Toast.makeText(this, message, Toast.LENGTH_LONG).show()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
