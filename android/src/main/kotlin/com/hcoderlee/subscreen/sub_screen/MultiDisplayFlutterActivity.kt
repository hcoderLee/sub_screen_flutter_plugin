package com.hcoderlee.subscreen.sub_screen

import android.app.Presentation
import android.os.Bundle
import android.view.Display
import androidx.annotation.CallSuper
import io.flutter.embedding.android.FlutterActivity

open class MultiDisplayFlutterActivity : FlutterActivity() {

    companion object {
        private const val SUB_SCREEN_ENTRY_POINT = "subScreenEntry"
    }

    protected var subScreenPresentation: Presentation? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        FlutterEngineHelper.init(this)
        super.onCreate(savedInstanceState)
        MultiDisplayHandler.init(this)
        MultiDisplayHandler.setSubScreenLauncher(object : ISubScreenLauncher {
            override fun launchSubScreen(display: Display) {
                onLaunchSubScreen(display)
            }

            override fun removeSubScreen(displayId: Int) {
                if (displayId == subScreenPresentation?.display?.displayId) {
                    onCloseSubScreen()
                }
            }

        })
    }

    override fun getCachedEngineGroupId(): String? {
        return FlutterEngineHelper.ENGINE_GROUP_ID
    }

    /**
     * Return the entry point function name for the flutter engine of sub screen
     */
    protected open fun getSubScreenEntryPoint(): String? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        MultiDisplayHandler.dispose()
        onCloseSubScreen()
    }

    @CallSuper
    protected open fun onLaunchSubScreen(display: Display) {
        // The entry function name for the flutter engine of sub screen
        val subScreenEntryPoint = getSubScreenEntryPoint() ?: SUB_SCREEN_ENTRY_POINT

        subScreenPresentation = createSubScreenPresentation(display) ?: FlutterPresentation(
            context,
            display,
            subScreenEntryPoint
        ).apply {
            show()
        }
    }

    @CallSuper
    protected open fun onCloseSubScreen() {
        subScreenPresentation?.dismiss()
        subScreenPresentation = null
    }

    protected fun <T : FlutterPresentation> createSubScreenPresentation(display: Display): T? {
        return null
    }
}