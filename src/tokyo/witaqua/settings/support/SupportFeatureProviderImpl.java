/*
 * Copyright (C) 2026 WitAqua
 * SPDX-License-Identifier: Apache-2.0
 */

package tokyo.witaqua.settings.support;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.preference.Preference;

import com.android.settings.R;
import com.android.settings.overlay.SupportFeatureProvider;
import com.android.settingslib.search.SearchIndexableRaw;

/**
 * Points the "Tips & support" entry at the WitAqua Wiki.
 */
public class SupportFeatureProviderImpl implements SupportFeatureProvider {

    private static final String TAG = "SupportFeatureProvider";

    @Override
    public void startSupport(Activity activity) {
        final Intent intent = new Intent(Intent.ACTION_VIEW,
                Uri.parse(activity.getString(R.string.witaqua_wiki_url)));
        try {
            activity.startActivity(intent);
        } catch (ActivityNotFoundException e) {
            Log.w(TAG, "No activity found to open the WitAqua Wiki", e);
        }
    }

    @Override
    public void applyOverrides(@NonNull Context context, @NonNull Preference pref) {
        pref.setSummary(R.string.witaqua_wiki_summary);
    }

    @Override
    public void applyOverrides(@NonNull Context context, @NonNull SearchIndexableRaw data) {
        data.summaryOn = context.getString(R.string.witaqua_wiki_summary);
    }
}
