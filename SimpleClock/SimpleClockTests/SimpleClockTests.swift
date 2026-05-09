//
//  SimpleClockTests.swift
//  SimpleClockTests
//
//  Created by Lorenz Pennewiss on 12.04.26.
//

import Foundation
import SwiftUI
import Testing
@testable import SimpleClock

struct SimpleClockTests {

    // MARK: - AppSettings

    @Test func appSettingsDefaultValues() {
        let suiteName = "test.simpleclock.defaults"
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        let settings = AppSettings(defaults: UserDefaults(suiteName: suiteName)!)
        #expect(settings.showSeconds == true)
        #expect(settings.showDate == true)
        #expect(settings.blinkingColon == false)
        #expect(settings.showSettingsIcon == true)
        #expect(settings.darkMode == nil)
    }

    @Test func appSettingsPersistsAcrossInstances() {
        let suiteName = "test.simpleclock.persistence"
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        let defaults = UserDefaults(suiteName: suiteName)!

        let first = AppSettings(defaults: defaults)
        first.showSeconds = false
        first.showDate = false
        first.blinkingColon = true
        first.showSettingsIcon = false
        first.darkMode = true

        let second = AppSettings(defaults: defaults)
        #expect(second.showSeconds == false)
        #expect(second.showDate == false)
        #expect(second.blinkingColon == true)
        #expect(second.showSettingsIcon == false)
        #expect(second.darkMode == true)
    }

    // MARK: - colonColor

    @Test func colonColorDefaultIsNil() {
        let suiteName = "test.simpleclock.coloncolor.default"
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        let settings = AppSettings(defaults: UserDefaults(suiteName: suiteName)!)
        #expect(settings.colonColor == nil)
    }

    @Test func colonColorPersistsComponents() {
        let suiteName = "test.simpleclock.coloncolor.persist"
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        let defaults = UserDefaults(suiteName: suiteName)!

        let settings = AppSettings(defaults: defaults)
        settings.colonColor = Color(red: 1.0, green: 0.42, blue: 0.208, opacity: 1.0)

        let stored = defaults.object(forKey: "simpleclock.colonColor") as? [Double]
        #expect(stored?.count == 4)
        #expect(stored != nil)
    }

    @Test func colonColorRoundtripsAcrossInstances() {
        let suiteName = "test.simpleclock.coloncolor.roundtrip"
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        let defaults = UserDefaults(suiteName: suiteName)!

        let first = AppSettings(defaults: defaults)
        first.colonColor = Color(red: 0.2, green: 0.6, blue: 0.9, opacity: 1.0)

        let second = AppSettings(defaults: defaults)
        #expect(second.colonColor != nil)

        let original = first.colonColor!.rgbaComponents!
        let reloaded = second.colonColor!.rgbaComponents!
        #expect(original.count == reloaded.count)
        for (a, b) in zip(original, reloaded) {
            #expect(abs(a - b) < 0.01)
        }
    }

    @Test func colonColorNilRemovesKey() {
        let suiteName = "test.simpleclock.coloncolor.nilreset"
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        let defaults = UserDefaults(suiteName: suiteName)!

        let settings = AppSettings(defaults: defaults)
        settings.colonColor = Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0)
        settings.colonColor = nil

        #expect(defaults.object(forKey: "simpleclock.colonColor") == nil)

        let reloaded = AppSettings(defaults: defaults)
        #expect(reloaded.colonColor == nil)
    }

    @Test func appSettingsDarkModeNilRoundtrips() {
        let suiteName = "test.simpleclock.darkmode"
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        let defaults = UserDefaults(suiteName: suiteName)!

        let settings = AppSettings(defaults: defaults)
        settings.darkMode = true
        settings.darkMode = nil

        let reloaded = AppSettings(defaults: defaults)
        #expect(reloaded.darkMode == nil)
    }

}
