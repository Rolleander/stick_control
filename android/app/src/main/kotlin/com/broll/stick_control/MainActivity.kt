package com.broll.stick_control

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.brol.stickcontrol/oboe"

    private val oboe = OboePlayer()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "init" -> oboe.init().also { result.success(null) }
                "play" -> oboe.play(call.argument<Int>("id")!!)
                "load" -> oboe.load(result,call.argument<String>("path")!! )
                else -> result.notImplemented()
            }
        }
    }

}
