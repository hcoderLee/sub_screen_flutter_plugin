package com.hcoderlee.subscreen.sub_screen

import android.app.Presentation
import android.os.Bundle
import android.view.Display
import io.flutter.embedding.android.FlutterActivity

open class MultiDisplayFlutterActivity : FlutterActivity() {

    companion object {
        private const val SUB_SCREEN_ENTRY_POINT = "subScreenEntry"
    }

    private var subScreenPresentation: Presentation? = null

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
                    onCloseSubScreenPresentation()
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
    protected fun getSubScreenEntryPoint(): String? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        MultiDisplayHandler.dispose()
        onCloseSubScreenPresentation()
    }

    private fun onLaunchSubScreen(display: Display) {
        // The entry function name for the flutter engine of sub screen
        val subScreenEntryPoint = getSubScreenEntryPoint() ?: SUB_SCREEN_ENTRY_POINT

        subScreenPresentation = FlutterPresentation(
            context,
            display,
            subScreenEntryPoint
        ).apply {
            show()
        }
    }

    private fun onCloseSubScreenPresentation() {
        subScreenPresentation?.dismiss()
        subScreenPresentation = null
    }
}