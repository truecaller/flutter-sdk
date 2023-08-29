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
import android.content.Intent
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import com.google.gson.Gson
import com.truecaller.android.sdk.oAuth.CodeVerifierUtil
import com.truecaller.android.sdk.oAuth.TcOAuthCallback
import com.truecaller.android.sdk.oAuth.TcOAuthData
import com.truecaller.android.sdk.oAuth.TcOAuthError
import com.truecaller.android.sdk.oAuth.TcSdk
import com.truecaller.android.sdk.oAuth.TcSdkOptions
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.math.BigInteger
import java.security.SecureRandom
import java.util.Locale


const val INITIATE_SDK = "initiateSDK"
const val IS_USABLE = "isUsable"
const val SET_DARK_THEME = "setDarkTheme"
const val SET_LOCALE = "setLocale"
const val GET_PROFILE = "getProfile"
const val REQUEST_VERIFICATION = "requestVerification"
const val VERIFY_OTP = "verifyOtp"
const val VERIFY_MISSED_CALL = "verifyMissedCall"
const val TC_METHOD_CHANNEL = "tc_method_channel"
const val TC_EVENT_CHANNEL = "tc_event_channel"

/** TruecallerSdkPlugin */
public class TruecallerSdkPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler,
    ActivityAware, PluginRegistry.ActivityResultListener {

    /** The MethodChannel that will the communication between Flutter and native Android
     * This local reference serves to register the plugin with the Flutter Engine and unregister it
     * when the Flutter Engine is detached from the Activity
     **/
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private var activity: Activity? = null
    private var codeVerifier: String = ""

    private val gson = Gson()

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
                getTrueScope(call)?.let {
                    TcSdk.init(it)

                } ?: result.error("UNAVAILABLE", "Activity not available.", null)
            }
            IS_USABLE -> {
                result.success(TcSdk.getInstance() != null && TcSdk.getInstance().isOAuthFlowUsable)
            }
            SET_DARK_THEME -> {
                //TcSdk.getInstance().set(Sd.DARK)
            }
            SET_LOCALE -> {
                call.argument<String>(Constants.LOCALE)?.let {
                    TcSdk.getInstance().setLocale(Locale(it))
                }
            }
            GET_PROFILE -> {
                activity?.let {
                    val stateRequested = BigInteger(130, SecureRandom()).toString(32)
                    TcSdk.getInstance().setOAuthState(stateRequested)


                    TcSdk.getInstance().setOAuthScopes(arrayOf("phone","profile"))

                    codeVerifier = CodeVerifierUtil.generateRandomCodeVerifier()

                    val codeChallenge : String? = CodeVerifierUtil.getCodeChallenge(codeVerifier)
                    codeChallenge?.let {
                        TcSdk.getInstance().setCodeChallenge(it)
                    } ?: result.error(
                        "UNAVAILABLE",
                        "Code challenge not available",
                        null)

                    TcSdk.getInstance().getAuthorizationCode(it as FragmentActivity)

                } ?: result.error(
                    "UNAVAILABLE",
                    "Activity not available.",
                    null
                )
            }
            /*REQUEST_VERIFICATION -> {
                val phoneNumber = call.argument<String>(Constants.PH_NO)?.takeUnless(String::isBlank)
                    ?: return result.error("Invalid phone", "Can't be null or empty", null)
                val countryISO = call.argument<String>(Constants.COUNTRY_ISO) ?: "IN"
                activity?.let {
                    try {
                        TruecallerSDK.getInstance()
                            .requestVerification(countryISO, phoneNumber, verificationCallback, it as FragmentActivity)
                    } catch (e: RuntimeException) {
                        result.error(e.message ?: "UNAVAILABLE", e.message ?: "UNAVAILABLE", null)
                    }
                }
                    ?: result.error("UNAVAILABLE", "Activity not available.", null)
            }*/
            /*VERIFY_OTP -> {
                val firstName = call.argument<String>(Constants.FIRST_NAME)?.takeUnless(String::isBlank)
                    ?: return result.error("Invalid name", "Can't be null or empty", null)
                val lastName = call.argument<String>(Constants.LAST_NAME) ?: ""
                val trueProfile = TrueProfile.Builder(firstName, lastName).build()
                val otp = call.argument<String>(Constants.OTP)?.takeUnless(String::isBlank)
                    ?: return result.error("Invalid otp", "Can't be null or empty", null)
                TruecallerSDK.getInstance().verifyOtp(
                    trueProfile,
                    otp,
                    verificationCallback
                )
            }
            VERIFY_MISSED_CALL -> {
                val firstName = call.argument<String>(Constants.FIRST_NAME)?.takeUnless(String::isBlank)
                    ?: return result.error("Invalid name", "Can't be null or empty", null)
                val lastName = call.argument<String>(Constants.LAST_NAME) ?: ""
                val trueProfile = TrueProfile.Builder(firstName, lastName).build()
                TruecallerSDK.getInstance().verifyMissedCall(
                    trueProfile,
                    verificationCallback
                )
            }*/
            else -> {
                result.notImplemented()
            }
        }
    }



    private fun getTrueScope(call: MethodCall): TcSdkOptions? {



        return activity?.let {




            TcSdkOptions.Builder(it, tcOAuthCallback)
                .sdkOptions(call.argument<Int>(Constants.SDK_OPTION) ?: TcSdkOptions.OPTION_VERIFY_ONLY_TC_USERS)
                .buttonColor(call.argument<Long>(Constants.BTN_CLR)?.toInt() ?: 0)
                .buttonTextColor(call.argument<Long>(Constants.BTN_TXT_CLR)?.toInt() ?: 0)
                .loginTextPrefix(call.argument<Int>(Constants.LOGIN_TEXT_PRE) ?: TcSdkOptions.LOGIN_TEXT_PREFIX_TO_GET_STARTED)
                .ctaText(call.argument<Int>(Constants.CTA_TEXT_PRE) ?: TcSdkOptions.CTA_TEXT_CONTINUE)
                .buttonShapeOptions(call.argument<Int>(Constants.BTN_SHAPE) ?: TcSdkOptions.BUTTON_SHAPE_ROUNDED)
                .footerType(call.argument<Int>(Constants.FOOTER_TYPE) ?: TcSdkOptions.FOOTER_TYPE_SKIP)
                .consentTitleOption(TcSdkOptions.SDK_CONSENT_HEADING_LOG_IN_TO)
                .build()


            /* TruecallerSdkScope.Builder(it, sdkCallback)
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
                 .build()*/
        }
    }




    private val tcOAuthCallback: TcOAuthCallback = object : TcOAuthCallback {


        override fun onSuccess(tcOAuthData: TcOAuthData) {
            val jsonElement = gson.toJsonTree(tcOAuthData)
            jsonElement.asJsonObject.addProperty("codeVerifier", codeVerifier);

            eventSink?.success(
                mapOf(
                    Constants.RESULT to Constants.SUCCESS,
                    Constants.DATA to
                            gson.toJson(jsonElement)

                )
            )
        }

        override fun onFailure(tcOAuthError: TcOAuthError) {


            eventSink?.success(
                mapOf(
                    Constants.RESULT to Constants.FAILURE,
                    Constants.DATA to gson.toJson(tcOAuthError)
                )
            )
        }

        override fun onVerificationRequired(tcOAuthError: TcOAuthError?) {

            eventSink?.success(
                mapOf(
                    Constants.RESULT to Constants.VERIFICATION,
                    Constants.DATA to gson.toJson(tcOAuthError)
                )
            )

        }
    }



    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        this.eventSink = eventSink
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        cleanUp()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        binding.addActivityResultListener(this)
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return if (requestCode == TcSdk.SHARE_PROFILE_REQUEST_CODE) {
            TcSdk.getInstance().onActivityResultObtained(activity as FragmentActivity, requestCode, resultCode, data)
        }
        else
            false
    }


    override fun onDetachedFromActivity() {
        cleanUp()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        cleanUp()
    }

    private fun cleanUp() {
        TcSdk.clear()
        activity = null
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        eventChannel?.setStreamHandler(null)
        eventChannel = null
        eventSink = null
    }
}
