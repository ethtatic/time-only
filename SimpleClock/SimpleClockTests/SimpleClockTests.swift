//
//  SimpleClockTests.swift
//  SimpleClockTests
//
//  Created by Lorenz Pennewiss on 12.04.26.
//

import Foundation
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
