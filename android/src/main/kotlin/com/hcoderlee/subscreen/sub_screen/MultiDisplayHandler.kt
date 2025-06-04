package com.hcoderlee.subscreen.sub_screen

import android.content.Context
import android.content.Context.DISPLAY_SERVICE
import android.hardware.display.DisplayManager
import android.hardware.display.DisplayManager.DisplayListener
import android.view.Display

object MultiDisplayHandler {
    var hasInit = false
    private lateinit var displayManager: DisplayManager
    private var subScreenLauncher: ISubScreenLauncher? = null

    private val displayListener = object : DisplayListener {
        override fun onDisplayAdded(displayId: Int) {
            val display = displayManager.getDisplay(displayId)
            if (!display.isDefault()) {
                subScreenLauncher?.launchSubScreen(display)
            }
            SubScreenPlugin.multiDisplayCallback.onDisplayAdded(display)
        }

        override fun onDisplayChanged(displayId: Int) {
            val display = displayManager.getDisplay(displayId)
            SubScreenPlugin.multiDisplayCallback.onDisplayChange(display)
        }

        override fun onDisplayRemoved(displayId: Int) {
            subScreenLauncher?.removeSubScreen(displayId)
            SubScreenPlugin.multiDisplayCallback.onDisplayRemoved(displayId)
        }
    }

    val displays: Array<Display> get() = displayManager.displays

    fun init(context: Context) {
        if (hasInit) {
            return
        }
        hasInit = true

        displayManager = context.getSystemService(DISPLAY_SERVICE) as DisplayManager
        displayManager.registerDisplayListener(displayListener, null)
    }

    fun setSubScreenLauncher(launcher: ISubScreenLauncher) {
        subScreenLauncher = launcher
        checkAndLaunchSubScreen()
    }

    fun dispose() {
        displayManager.unregisterDisplayListener(displayListener)
    }

    private fun checkAndLaunchSubScreen() {
        val subDisplay = displayManager.displays.firstOrNull { !it.isDefault() }
        subDisplay?.let { display ->
            subScreenLauncher?.launchSubScreen(display)
        }
    }
}

interface ISubScreenLauncher {
    fun launchSubScreen(display: Display)
    fun removeSubScreen(displayId: Int)
}

fun Display.isDefault() = displayId == Display.DEFAULT_DISPLAY
