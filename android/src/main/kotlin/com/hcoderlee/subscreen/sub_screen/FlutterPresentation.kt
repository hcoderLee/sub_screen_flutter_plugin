package com.hcoderlee.subscreen.sub_screen

import android.app.Presentation
import android.content.Context
import android.os.Bundle
import android.view.Display
import android.widget.FrameLayout
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineGroupCache
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint

class FlutterPresentation(
    context: Context,
    display: Display,
    val entryPointFun: String
) : Presentation(context, display) {
    private lateinit var flutterEngine: FlutterEngine
    private lateinit var flutterView: FlutterView
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        flutterView = FlutterView(context)
        flutterView.layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        setContentView(flutterView)

        val engineGroup =
            FlutterEngineGroupCache.getInstance().get(FlutterEngineHelper.ENGINE_GROUP_ID)
        val entryPoint = DartEntrypoint(
            FlutterInjector.instance().flutterLoader().findAppBundlePath(),
            entryPointFun
        )
        flutterEngine = engineGroup!!.createAndRunEngine(context, entryPoint)
        flutterView.attachToFlutterEngine(flutterEngine)
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
    }

    override fun show() {
        super.show()
        flutterEngine.lifecycleChannel.appIsResumed()
    }

    override fun dismiss() {
        flutterView.detachFromFlutterEngine()
        flutterEngine.lifecycleChannel.appIsDetached()
        flutterEngine.activityControlSurface.detachFromActivity()
        flutterEngine.destroy()
        super.dismiss()
    }
}