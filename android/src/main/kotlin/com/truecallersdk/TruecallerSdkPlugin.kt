/*
 * TRUECALLER SDK COPYRIGHT, TRADEMARK AND LICENSE NOTICE
 *
 * Copyright © 2015-Present, True Software Scandinavia AB. All rights reserved.
 *
 * Truecaller and Truecaller SDK are registered trademark of True Software Scandinavia AB.
 *
 * In accordance with the Truecaller SDK Agreement available
 * here (https://developer.truecaller.com/Truecaller-sdk-product-license-agreement-RoW.pdf)
 * accepted and agreed between You and Your respective Truecaller entity, You are granted a
 * limited, non-exclusive, non-sublicensable, non-transferable, royalty-free, license to use the
 * Truecaller SDK Product in object code form only, solely for the purpose of using
 * the Truecaller SDK Product with the applications and APIs provided by Truecaller.
 *
 * THE TRUECALLER SDK PRODUCT IS PROVIDED BY THE COPYRIGHT HOLDER AND AUTHOR “AS IS”,
 * WITHOUT WARRANTY OF ANY KIND,EXPRESS OR IMPLIED,INCLUDING BUT NOT LIMITED
 * TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
 * SOFTWARE QUALITY,PERFORMANCE,DATA ACCURACY AND NON-INFRINGEMENT. IN NO
 * EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES OR
 * OTHER LIABILITY INCLUDING BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION: HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THE TRUECALLER SDK PRODUCT OR THE USE
 * OR OTHER DEALINGS IN THE TRUECALLER SDK PRODUCT, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE. AS A RESULT, BY INTEGRATING THE TRUECALLER SDK
 * PRODUCT YOU ARE ASSUMING THE ENTIRE RISK AS TO ITS QUALITY AND PERFORMANCE.
 */

package com.truecallersdk

import android.app.Activity
import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import com.google.gson.Gson
import com.truecaller.android.sdk.ITrueCallback
import com.truecaller.android.sdk.SdkThemeOptions
import com.truecaller.android.sdk.TrueError
import com.truecaller.android.sdk.TrueProfile
import com.truecaller.android.sdk.TruecallerSDK
import com.truecaller.android.sdk.TruecallerSdkScope
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.Locale

const val INITIATE_SDK = "initiateSDK"
const val IS_USABLE = "isUsable"
const val SET_DARK_THEME = "setDarkTheme"
const val SET_LOCALE = "setLocale"
const val GET_PROFILE = "getProfile"
const val TC_METHOD_CHANNEL = "tc_method_channel"
const val TC_EVENT_CHANNEL = "tc_event_channel"

/** TruecallerSdkPlugin */
public class TruecallerSdkPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware {

    /** The MethodChannel that will the communication between Flutter and native Android
     * This local reference serves to register the plugin with the Flutter Engine and unregister it
     * when the Flutter Engine is detached from the Activity
     **/
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        onAttachedToEngine(flutterPluginBinding.binaryMessenger)
    }

    /**This static function is optional and equivalent to onAttachedToEngine. It supports the old
     * pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
     * plugin registration via this function while apps migrate to use the new Android APIs
     * post-flutter-1.12 via https:flutter.dev/go/android-project-migration.
     * It is encouraged to share logic between onAttachedToEngine and registerWith to keep
     * them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
     * depending on the user's project. onAttachedToEngine or registerWith must both be defined
     * in the same class.
     **/
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val truecallerSdkPlugin = TruecallerSdkPlugin()
            truecallerSdkPlugin.activity = registrar.activity()
            truecallerSdkPlugin.onAttachedToEngine(registrar.messenger())
        }
    }

    private fun onAttachedToEngine(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, TC_METHOD_CHANNEL)
        methodChannel?.setMethodCallHandler(this)
        eventChannel = EventChannel(messenger, TC_EVENT_CHANNEL)
        eventChannel?.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            INITIATE_SDK -> {
                getTrueScope(call)?.let { TruecallerSDK.init(it) } ?: result.error("UNAVAILABLE", "Activity not available.", null)
            }
            IS_USABLE -> {
                result.success(TruecallerSDK.getInstance() != null && TruecallerSDK.getInstance().isUsable)
            }
            SET_DARK_THEME -> {
                TruecallerSDK.getInstance().setTheme(SdkThemeOptions.DARK)
            }
            SET_LOCALE -> {
                call.argument<String>(Constants.LOCALE)?.let {
                    TruecallerSDK.getInstance().setLocale(Locale(it))
                }
            }
            GET_PROFILE -> {
                activity?.let { TruecallerSDK.getInstance().getUserProfile(it as FragmentActivity) } ?: result.error(
                    "UNAVAILABLE",
                    "Activity not available.",
                    null
                )
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getTrueScope(call: MethodCall): TruecallerSdkScope? {
        return activity?.let {
            TruecallerSdkScope.Builder(it, sdkCallback)
                .sdkOptions(call.argument<Int>(Constants.SDK_OPTION) ?: TruecallerSdkScope.SDK_OPTION_WITHOUT_OTP)
                .consentMode(call.argument<Int>(Constants.CONSENT_MODE) ?: TruecallerSdkScope.CONSENT_MODE_BOTTOMSHEET)
                .consentTitleOption(call.argument<Int>(Constants.CONSENT_TITLE) ?: TruecallerSdkScope.SDK_CONSENT_TITLE_GET_STARTED)
                .footerType(call.argument<Int>(Constants.FOOTER_TYPE) ?: TruecallerSdkScope.FOOTER_TYPE_SKIP)
                .loginTextPrefix(call.argument<Int>(Constants.LOGIN_TEXT_PRE) ?: TruecallerSdkScope.LOGIN_TEXT_PREFIX_TO_GET_STARTED)
                .loginTextSuffix(call.argument<Int>(Constants.LOGIN_TEXT_SUF) ?: TruecallerSdkScope.LOGIN_TEXT_SUFFIX_PLEASE_LOGIN)
                .ctaTextPrefix(call.argument<Int>(Constants.CTA_TEXT_PRE) ?: TruecallerSdkScope.CTA_TEXT_PREFIX_USE)
                .privacyPolicyUrl(call.argument<String>(Constants.PP_URL) ?: "")
                .termsOfServiceUrl(call.argument<String>(Constants.TOS_URL) ?: "")
                .buttonShapeOptions(call.argument<Int>(Constants.BTN_SHAPE) ?: TruecallerSdkScope.BUTTON_SHAPE_ROUNDED)
                .buttonColor(call.argument<Long>(Constants.BTN_CLR)?.toInt() ?: 0)
                .buttonTextColor(call.argument<Long>(Constants.BTN_TXT_CLR)?.toInt() ?: 0)
                .build()
        }
    }

    private val sdkCallback: ITrueCallback = object : ITrueCallback {
        override fun onSuccessProfileShared(trueProfile: TrueProfile) {
            eventSink?.success(
                mapOf(
                    Constants.RESULT to Constants.SUCCESS,
                    Constants.DATA to Gson().toJson(trueProfile)
                )
            )
        }

        override fun onFailureProfileShared(trueError: TrueError) {
            eventSink?.success(
                mapOf(
                    Constants.RESULT to Constants.FAILURE,
                    Constants.DATA to Gson().toJson(trueError)
                )
            )
        }

        override fun onVerificationRequired() {
            eventSink?.success(mapOf(Constants.RESULT to Constants.VERIFICATION))
        }
    }

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        this.eventSink = eventSink
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        activity = null
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        eventChannel?.setStreamHandler(null)
        eventChannel = null
        eventSink = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        binding.addActivityResultListener { _, resultCode, data ->
            TruecallerSDK.getInstance().onActivityResultObtained(activity as FragmentActivity, resultCode, data)
        }
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        binding.addActivityResultListener { _, resultCode, data ->
            TruecallerSDK.getInstance().onActivityResultObtained(activity as FragmentActivity, resultCode, data)
        }
    }

    override fun onDetachedFromActivity() {
        this.activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.activity = null
    }
}
