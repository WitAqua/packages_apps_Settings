[1mdiff --git a/src/com/android/settings/deviceinfo/firmwareversion/LineageVersionDetailPreference.kt b/src/com/android/settings/deviceinfo/firmwareversion/LineageVersionDetailPreference.kt[m
[1mindex 082e7d7cc23..2ae45b3a120 100644[m
[1m--- a/src/com/android/settings/deviceinfo/firmwareversion/LineageVersionDetailPreference.kt[m
[1m+++ b/src/com/android/settings/deviceinfo/firmwareversion/LineageVersionDetailPreference.kt[m
[36m@@ -17,18 +17,10 @@[m
 package com.android.settings.deviceinfo.firmwareversion[m
 [m
 import android.content.Context[m
[31m-import android.content.Intent[m
[31m-import android.os.Build[m
[31m-import android.os.SystemClock[m
 import android.os.SystemProperties[m
[31m-import android.os.UserHandle[m
[31m-import android.os.UserManager[m
 import androidx.preference.Preference[m
 import com.android.settings.R[m
[31m-import com.android.settings.Utils[m
 import com.android.settings.contract.TAG_DEVICE_STATE_PREFERENCE[m
[31m-import com.android.settingslib.RestrictedLockUtils[m
[31m-import com.android.settingslib.RestrictedLockUtilsInternal[m
 import com.android.settingslib.metadata.PreferenceMetadata[m
 import com.android.settingslib.metadata.PreferenceSummaryProvider[m
 import com.android.settingslib.preference.PreferenceBinding[m
[36m@@ -38,8 +30,6 @@[m [mclass LineageVersionDetailPreference :[m
     PreferenceMetadata, PreferenceSummaryProvider, PreferenceBinding,[m
     Preference.OnPreferenceClickListener {[m
 [m
[31m-    private val hits = LongArray(ACTIVITY_TRIGGER_COUNT)[m
[31m-[m
     override val key: String[m
         get() = "lineage_version"[m
 [m
[36m@@ -54,11 +44,6 @@[m [mclass LineageVersionDetailPreference :[m
 [m
     override fun tags(context: Context) = arrayOf(TAG_DEVICE_STATE_PREFERENCE)[m
 [m
[31m-    override fun intent(context: Context): Intent? =[m
[31m-        Intent(Intent.ACTION_MAIN)[m
[31m-            .setClassName(PLATLOGO_PACKAGE_NAME, PLATLOGO_ACTIVITY_CLASS)[m
[31m-            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)[m
[31m-[m
     override fun bind(preference: Preference, metadata: PreferenceMetadata) {[m
         super.bind(preference, metadata)[m
         preference.isCopyingEnabled = true[m
[36m@@ -70,45 +55,11 @@[m [mclass LineageVersionDetailPreference :[m
 [m
     // return true swallows the click event, while return false will start the intent[m
     override fun onPreferenceClick(preference: Preference): Boolean {[m
[31m-        if (Utils.isMonkeyRunning()) return true[m
[31m-[m
[31m-        // remove oldest hit and check whether there are 3 clicks within 500ms[m
[31m-        for (index in 1..<ACTIVITY_TRIGGER_COUNT) hits[index - 1] = hits[index][m
[31m-        hits[ACTIVITY_TRIGGER_COUNT - 1] = SystemClock.uptimeMillis()[m
[31m-        if (hits[ACTIVITY_TRIGGER_COUNT - 1] - hits[0] > DELAY_TIMER_MILLIS) return true[m
[31m-[m
[31m-        val context = preference.context[m
[31m-        val userManager = context.getSystemService(Context.USER_SERVICE) as? UserManager[m
[31m-        if (userManager?.hasUserRestriction(UserManager.DISALLOW_FUN) != true) return false[m
[31m-[m
[31m-        // Sorry, no fun for you![m
[31m-        val myUserId = UserHandle.myUserId()[m
[31m-        val enforcedAdmin =[m
[31m-            RestrictedLockUtilsInternal.checkIfRestrictionEnforced([m
[31m-                context,[m
[31m-                UserManager.DISALLOW_FUN,[m
[31m-                myUserId,[m
[31m-            ) ?: return true[m
[31m-        val disallowedBySystem =[m
[31m-            RestrictedLockUtilsInternal.hasBaseUserRestriction([m
[31m-                context,[m
[31m-                UserManager.DISALLOW_FUN,[m
[31m-                myUserId,[m
[31m-            )[m
[31m-        if (!disallowedBySystem) {[m
[31m-            RestrictedLockUtils.sendShowAdminSupportDetailsIntent(context, enforcedAdmin)[m
[31m-        }[m
         return true[m
     }[m
 [m
     companion object {[m
[31m-        const val ACTIVITY_TRIGGER_COUNT = 3[m
[31m-        const val DELAY_TIMER_MILLIS = 500L[m
[31m-[m
         const val LINEAGE_VERSION_PROPERTY: String = "ro.witaqua.build.version"[m
[31m-[m
[31m-        const val PLATLOGO_PACKAGE_NAME: String = "org.lineageos.lineageparts"[m
[31m-        const val PLATLOGO_ACTIVITY_CLASS: String = PLATLOGO_PACKAGE_NAME + ".logo.PlatLogoActivity"[m
     }[m
 }[m
 // LINT.ThenChange(LineageVersionDetailPreferenceController.java)[m
[1mdiff --git a/src/com/android/settings/deviceinfo/firmwareversion/LineageVersionDetailPreferenceController.java b/src/com/android/settings/deviceinfo/firmwareversion/LineageVersionDetailPreferenceController.java[m
[1mindex a63828820de..2eb01fdbf36 100644[m
[1m--- a/src/com/android/settings/deviceinfo/firmwareversion/LineageVersionDetailPreferenceController.java[m
[1m+++ b/src/com/android/settings/deviceinfo/firmwareversion/LineageVersionDetailPreferenceController.java[m
[36m@@ -17,47 +17,21 @@[m
 package com.android.settings.deviceinfo.firmwareversion;[m
 [m
 import android.content.Context;[m
[31m-import android.content.Intent;[m
[31m-import android.os.Build;[m
[31m-import android.os.SystemClock;[m
 import android.os.SystemProperties;[m
[31m-import android.os.UserHandle;[m
[31m-import android.os.UserManager;[m
[31m-import android.text.TextUtils;[m
[31m-import android.util.Log;[m
[31m-[m
[31m-import androidx.annotation.VisibleForTesting;[m
 import androidx.preference.Preference;[m
 [m
 import com.android.settings.R;[m
[31m-import com.android.settings.Utils;[m
 import com.android.settings.core.BasePreferenceController;[m
[31m-import com.android.settingslib.RestrictedLockUtils;[m
[31m-import com.android.settingslib.RestrictedLockUtilsInternal;[m
 [m
 // LINT.IfChange[m
 public class LineageVersionDetailPreferenceController extends BasePreferenceController {[m
 [m
     private static final String TAG = "lineageVersionDialogCtrl";[m
[31m-    private static final int DELAY_TIMER_MILLIS = 500;[m
[31m-    private static final int ACTIVITY_TRIGGER_COUNT = 3;[m
 [m
     private static final String KEY_LINEAGE_VERSION_PROP = "ro.witaqua.build.version";[m
 [m
[31m-    private static final String PLATLOGO_PACKAGE_NAME = "org.lineageos.lineageparts";[m
[31m-    private static final String PLATLOGO_ACTIVITY_CLASS =[m
[31m-            PLATLOGO_PACKAGE_NAME + ".logo.PlatLogoActivity";[m
[31m-[m
[31m-    private final UserManager mUserManager;[m
[31m-    private final long[] mHits = new long[ACTIVITY_TRIGGER_COUNT];[m
[31m-[m
[31m-    private RestrictedLockUtils.EnforcedAdmin mFunDisallowedAdmin;[m
[31m-    private boolean mFunDisallowedBySystem;[m
[31m-[m
     public LineageVersionDetailPreferenceController(Context context, String key) {[m
         super(context, key);[m
[31m-        mUserManager = (UserManager) mContext.getSystemService(Context.USER_SERVICE);[m
[31m-        initializeAdminPermissions();[m
     }[m
 [m
     @Override[m
[36m@@ -83,49 +57,7 @@[m [mpublic class LineageVersionDetailPreferenceController extends BasePreferenceCont[m
 [m
     @Override[m
     public boolean handlePreferenceTreeClick(Preference preference) {[m
[31m-        if (!TextUtils.equals(preference.getKey(), getPreferenceKey())) {[m
[31m-            return false;[m
[31m-        }[m
[31m-        if (Utils.isMonkeyRunning()) {[m
[31m-            return false;[m
[31m-        }[m
[31m-        arrayCopy();[m
[31m-        mHits[mHits.length - 1] = SystemClock.uptimeMillis();[m
[31m-        if (mHits[0] >= (SystemClock.uptimeMillis() - DELAY_TIMER_MILLIS)) {[m
[31m-            if (mUserManager.hasUserRestriction(UserManager.DISALLOW_FUN)) {[m
[31m-                if (mFunDisallowedAdmin != null && !mFunDisallowedBySystem) {[m
[31m-                    RestrictedLockUtils.sendShowAdminSupportDetailsIntent(mContext,[m
[31m-                            mFunDisallowedAdmin);[m
[31m-                }[m
[31m-                Log.d(TAG, "Sorry, no fun for you!");[m
[31m-                return true;[m
[31m-            }[m
[31m-[m
[31m-            final Intent intent = new Intent(Intent.ACTION_MAIN)[m
[31m-                     .setClassName(PLATLOGO_PACKAGE_NAME, PLATLOGO_ACTIVITY_CLASS);[m
[31m-            try {[m
[31m-                mContext.startActivity(intent);[m
[31m-            } catch (Exception e) {[m
[31m-                Log.e(TAG, "Unable to start activity " + intent.toString());[m
[31m-            }[m
[31m-        }[m
         return true;[m
     }[m
[31m-[m
[31m-    /**[m
[31m-     * Copies the array onto itself to remove the oldest hit.[m
[31m-     */[m
[31m-    @VisibleForTesting[m
[31m-    void arrayCopy() {[m
[31m-        System.arraycopy(mHits, 1, mHits, 0, mHits.length - 1);[m
[31m-    }[m
[31m-[m
[31m-    @VisibleForTesting[m
[31m-    void initializeAdminPermissions() {[m
[31m-        mFunDisallowedAdmin = RestrictedLockUtilsInternal.checkIfRestrictionEnforced([m
[31m-                mContext, UserManager.DISALLOW_FUN, UserHandle.myUserId());[m
[31m-        mFunDisallowedBySystem = RestrictedLockUtilsInternal.hasBaseUserRestriction([m
[31m-                mContext, UserManager.DISALLOW_FUN, UserHandle.myUserId());[m
[31m-    }[m
 }[m
 // LINT.ThenChange(LineageVersionDetailPreference.kt)[m
