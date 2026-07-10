/*
 * SPDX-FileCopyrightText: WitAqua
 * SPDX-License-Identifier: Apache-2.0
 */

package com.android.settings.deviceinfo.firmwareversion

import android.content.Context
import android.os.SELinux
import androidx.preference.Preference
import com.android.settings.R
import com.android.settingslib.datastore.KeyValueStore
import com.android.settingslib.metadata.PersistentPreference
import com.android.settingslib.metadata.PreferenceMetadata
import com.android.settingslib.metadata.PreferenceSummaryProvider
import com.android.settingslib.metadata.SensitivityLevel
import com.android.settingslib.preference.PreferenceBinding

// LINT.IfChange
class SelinuxStatusPreference :
    PersistentPreference<String>, PreferenceMetadata, PreferenceSummaryProvider, PreferenceBinding {

    override val key: String
        get() = "selinux_status"

    override val purpose: Int
        get() = R.string.selinux_status_purpose

    override val title: Int
        get() = R.string.selinux_status

    override val supportsWrite = false

    override val valueType = String::class.javaObjectType

    override fun storage(context: Context): KeyValueStore = createSummaryStorage(context, key)

    override fun getSummary(context: Context): CharSequence? {
        if (!SELinux.isSELinuxEnabled()) {
            return context.getString(R.string.selinux_status_disabled);
        } else if (!SELinux.isSELinuxEnforced()) {
            return context.getString(R.string.selinux_status_permissive);
        } else {
            return context.getString(R.string.selinux_status_enforcing);
        }
    }

    override fun bind(preference: Preference, metadata: PreferenceMetadata) {
        super.bind(preference, metadata)
        preference.isSelectable = false
        preference.isCopyingEnabled = true
    }

    override val sensitivityLevel
        get() = SensitivityLevel.NO_SENSITIVITY

}
// LINT.ThenChange(SelinuxStatusPreferenceController.java)
