//
//  SettingsView.swift
//  SimpleClock
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: Binding(
                        get: { settings.darkMode ?? false },
                        set: { settings.darkMode = $0 }
                    ))

                    Toggle("Show Seconds", isOn: $settings.showSeconds)
                    Toggle("Show Date", isOn: $settings.showDate)
                }

                Section("Clock") {
                    Toggle("Blinking Colon", isOn: $settings.blinkingColon)

                    ColorPicker("Colon Color", selection: Binding(
                        get: { settings.colonColor ?? .dsAccent },
                        set: { settings.colonColor = $0 }
                    ), supportsOpacity: false)

                    if settings.colonColor != nil {
                        Button("Reset to Default") {
                            settings.colonColor = nil
                        }
                        .foregroundStyle(.secondary)
                    }
                }

                Section("Interface") {
                    Toggle("Show Settings Icon", isOn: $settings.showSettingsIcon)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
